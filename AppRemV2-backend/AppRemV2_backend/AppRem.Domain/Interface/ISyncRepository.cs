using AppRem.Domain.Core;
using AppRem.Domain.Entities.Operational;
using AppRem.Domain.Entities.Security;


namespace AppRem.Domain.Interface
{
    public interface ISyncRepository
    {
        //PUSH: save or update products in the database
        Task<Result<List<Guid>>> UpsertProductsAsync(IEnumerable<Product> products, Guid accountId);
        Task<Result<List<Guid>>> UpsertClientAsync(IEnumerable<Client> clients, Guid accountId);
        Task<Result<List<Guid>>> UpsertRemissionAsync(IEnumerable<Remission> remissions, Guid accountId);
        Task<Result<bool>> UpsertUserAsync(User user, Guid accountId);

        //PULL: download registers or updated after a specific date
        Task<Result<IEnumerable<Product>>> GetProductsSinceAsync(Guid accountId, DateTime since);
        Task<Result<IEnumerable<Client>>> GetClientsSinceAsync(Guid accountId, DateTime since);
        Task<Result<IEnumerable<Remission>>> GetRemissionsSinceAsync(Guid accountId, DateTime since);
    }
}
