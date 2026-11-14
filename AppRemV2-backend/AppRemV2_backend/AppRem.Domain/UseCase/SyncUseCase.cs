

using AppRem.Domain.Core;
using AppRem.Domain.Entities.Operational;
using AppRem.Domain.Entities.Security;
using AppRem.Domain.Interface;

namespace AppRem.Domain.UseCase
{
    public class SyncUseCase : ISyncUseCase
    {
        private readonly ISyncRepository _syncRepository;
        private readonly IAuthRepository _authRepository;
        private readonly IBlobStorageService _blobStorageService;
        public SyncUseCase(ISyncRepository syncRepository, IAuthRepository authRepository, IBlobStorageService blobStorageService)
        {
            _syncRepository = syncRepository;
            _authRepository = authRepository;
            _blobStorageService = blobStorageService;
           
        }
        //Validate the subscription, verify the Content-Type, and generate a secure name (GUID) before uploading the file
        public async Task<Result<string>> UploadFileAsync(Guid accountId, Stream fileStream, string contentType)
        {
            var accountResult = await _authRepository.GetAccountByIdAsync(accountId);
            if (!accountResult.IsSuccess)
                return Result<string>.Failure("Not found Account");

            var account = accountResult.Value;
            if (!account.IsSubscribed || !account.SubscriptionExpiration.HasValue || account.SubscriptionExpiration.Value <= DateTime.UtcNow)
                return Result<string>.Failure("The subscription is not active or has expired. New uploads are not permitted.");

            //Validate Content-Type
            string extension = contentType.ToLowerInvariant() switch
            {
                "image/png" => ".png",
                "image/jpeg" => ".jpg",
                "image/jpg" => ".jpg",
                _ => string.Empty
            };
            if (string.IsNullOrEmpty(extension))
                return Result<string>.Failure("File format not allowed. Only PNG or JPEG images are accepted.");

            //Generate Blob Name
            string safeBlobName = $"{accountId}/{Guid.NewGuid()}{extension}";

            return await _blobStorageService.UploadFileAsync(fileStream,accountId, safeBlobName, contentType);
        }

        //PULL flow: Downloads data from the cloud to the device.
        public async Task<Result<(IEnumerable<Product>, IEnumerable<Client>, IEnumerable<Remission>)>> PullDataAsync(Guid userId, Guid accountId, DateTime since)
        {
            // USer and account already exists
            var accountResult = await _authRepository.GetAccountByIdAsync(accountId);
            if (!accountResult.IsSuccess)
                return Result<(IEnumerable<Product>, IEnumerable<Client>, IEnumerable<Remission>)>.Failure("Account not found.");

            var account = accountResult.Value;
            // Only users with an active subscription can download data
            if (!account.IsSubscribed || !account.SubscriptionExpiration.HasValue || account.SubscriptionExpiration.Value <= DateTime.UtcNow)
                return Result<(IEnumerable<Product>, IEnumerable<Client>, IEnumerable<Remission>)>.Failure("Subscription inactive. Downloading of synchronization data is not permitted.");

            
            var productsResult = await _syncRepository.GetProductsSinceAsync(accountId, since);
            var clientsResult = await _syncRepository.GetClientsSinceAsync(accountId, since);
            var remissionsResult = await _syncRepository.GetRemissionsSinceAsync(accountId, since);

            if (!productsResult.IsSuccess) return Result<(IEnumerable<Product>, IEnumerable<Client>, IEnumerable<Remission>)>.Failure(productsResult.ErrorMessage!);
            if (!clientsResult.IsSuccess) return Result<(IEnumerable<Product>, IEnumerable<Client>, IEnumerable<Remission>)>.Failure(clientsResult.ErrorMessage!);
            if (!remissionsResult.IsSuccess) return Result<(IEnumerable<Product>, IEnumerable<Client>, IEnumerable<Remission>)>.Failure(remissionsResult.ErrorMessage!);

            return Result<(IEnumerable<Product>, IEnumerable<Client>, IEnumerable<Remission>)>.Success(
                (productsResult.Value!, clientsResult.Value!, remissionsResult.Value!)
            );
        }
        public async Task<Result<(List<Guid> products, List<Guid> clients, List<Guid> remissions)>> PushDataAsync(
     Guid accountId,
     User? user,
     IEnumerable<Product> products,
     IEnumerable<Client> clients,
     IEnumerable<Remission> remissions)
        {
            // 1. Validate active subscription AND expiration date (protects against lost webhooks)
            var accountResult = await _authRepository.GetAccountByIdAsync(accountId);
            if (!accountResult.IsSuccess || accountResult.Value == null)
                return Result<(List<Guid>, List<Guid>, List<Guid>)>.Failure("Account not found.");

            var account = accountResult.Value;
            if (!account.IsSubscribed || !account.SubscriptionExpiration.HasValue || account.SubscriptionExpiration.Value <= DateTime.UtcNow)
                return Result<(List<Guid>, List<Guid>, List<Guid>)>.Failure("Subscription inactive or expired. Uploading new data is not permitted.");

            // 2. Save User profile/signature changes if included in the push batch
            if (user != null)
            {
                var userResult = await _syncRepository.UpsertUserAsync(user, accountId);
                if (!userResult.IsSuccess)
                    return Result<(List<Guid>, List<Guid>, List<Guid>)>.Failure(userResult.ErrorMessage!);
            }

            // 3. Save Products
            var productsIdsResult = await _syncRepository.UpsertProductsAsync(products, accountId);
            if (!productsIdsResult.IsSuccess)
                return Result<(List<Guid>, List<Guid>, List<Guid>)>.Failure(productsIdsResult.ErrorMessage!);

            // 4. Save Clients
            var clientsIdsResult = await _syncRepository.UpsertClientAsync(clients, accountId);
            if (!clientsIdsResult.IsSuccess)
                return Result<(List<Guid>, List<Guid>, List<Guid>)>.Failure(clientsIdsResult.ErrorMessage!);

            // 5. Save Remissions with their DetailLines
            var remissionsIdsResult = await _syncRepository.UpsertRemissionAsync(remissions, accountId);
            if (!remissionsIdsResult.IsSuccess)
                return Result<(List<Guid>, List<Guid>, List<Guid>)>.Failure(remissionsIdsResult.ErrorMessage!);

            return Result<(List<Guid>, List<Guid>, List<Guid>)>.Success(
                (productsIdsResult.Value!, clientsIdsResult.Value!, remissionsIdsResult.Value!)
            );
        }


    }
}
