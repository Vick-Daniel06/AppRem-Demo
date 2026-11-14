using AppRem.Domain.Core;
using AppRem.Domain.Entities.Security;
using AppRem.Domain.Interface;
using System.Security.Cryptography;
using System.Text;


namespace AppRem.Domain.UseCase
{
    public class PaymentUseCase
    {
        private readonly IPaymentRepository _paymentRepository;
        private readonly IAuthRepository _authRepository;
        public PaymentUseCase(IPaymentRepository paymentRepository, IAuthRepository authRepository)
        {
            _paymentRepository = paymentRepository;
            _authRepository = authRepository;
        }
        //Processes the incoming webhook and updates cloud access.
        public async Task<Result<bool>> ProcessWebhookAsync(
            string authorizationHeader,
            string expectedSecret,
            Guid accountId,
            string store,
            string purchaseToken,
            string productId,
            string status,
            DateTime expiresAt)
        {

            //Validate Signature
            if (!IsSignatureValid(authorizationHeader, expectedSecret))
            {
                return Result<bool>.Failure("Invalid or unauthorized security signature.");
            }
            //If you retry sending the same notification due to a network failure
            var uniqueResult = await _paymentRepository.IsPurchaseTokenUniqueAsync(purchaseToken);
            if (!uniqueResult.IsSuccess) return Result<bool>.Failure(uniqueResult.ErrorMessage!);

            if (!uniqueResult.Value)
            {
                //if teh token alredy exists, return Success(HTTP 200) and stop insisting
                return Result<bool>.Success(true);
            }
            //Retrieve the affected account
            var accountResult = await _authRepository.GetAccountByIdAsync(accountId);
            if (!accountResult.IsSuccess)
            {
                return Result<bool>.Failure("Account not found for processing the payment event.");
            }
            var account = accountResult.Value!;

            // 4. Reglas de Negocio para el Acceso a la Nube
            string eventType = status.ToUpperInvariant(); // Aseguramos mayúsculas para evitar errores

            Result<bool> domainValidationResult;

            // Eventos que otorgan o mantienen el acceso activo
            if (eventType == "INITIAL_PURCHASE" ||
                eventType == "RENEWAL" ||
                eventType == "UNCANCELLATION" ||
                eventType == "PRODUCT_CHANGE")
            {
                // Invocamos tu método explícito que valida la fecha
                domainValidationResult = account.ActivateSubscription(expiresAt);
            }
            // Eventos que revocan el acceso definitivamente
            else if (eventType == "EXPIRATION")
            {
                // Invocamos tu método explícito que congela el acceso sin borrar datos
                domainValidationResult = account.FreezeAccount();
            }
            // Si es "CANCELLATION" (desactivó auto-renovación) u otro evento (ej. "TEST")
            else
            {
                // No congelamos la cuenta porque aún tiene tiempo vigente.
                // Simplemente marcamos la validación del dominio como exitosa para que
                // el log de la transacción se guarde en la BD, pero no afectamos a 'Account'.
                domainValidationResult = Result<bool>.Success(true);
            }

            // Si la entidad rechaza el cambio (ej. la fecha ya venció), abortamos
            if (!domainValidationResult.IsSuccess)
            {
                return Result<bool>.Failure(domainValidationResult.ErrorMessage!);
            }

            //Create an immutable record for payment audits
            var purchaseLogResult = PurchasesLog.Create(accountId, store, purchaseToken, productId, status, expiresAt, DateTime.UtcNow);
            if (!purchaseLogResult.IsSuccess)
            {
                return Result<bool>.Failure(purchaseLogResult.ErrorMessage!);
            }
            var logSaveResult = await _paymentRepository.SavePurchaseLogAsync(purchaseLogResult.Value!);
            if (!logSaveResult.IsSuccess)
                return Result<bool>.Failure(logSaveResult.ErrorMessage!);

            var accountUpdateResult = await _paymentRepository.UpdateAccountSubscriptionAsync(account);
            if (!accountUpdateResult.IsSuccess)
                return Result<bool>.Failure(accountUpdateResult.ErrorMessage!);

            return Result<bool>.Success(true);

        }
        private bool IsSignatureValid(string providedHeader, string expectedSecret)
        {
            if (string.IsNullOrWhiteSpace(providedHeader) || string.IsNullOrWhiteSpace(expectedSecret))
                return false;

            var providedBytes = Encoding.UTF8.GetBytes(providedHeader);
            var expectedBytes = Encoding.UTF8.GetBytes(expectedSecret);

            // La longitud diferente se descarta inmediatamente
            if (providedBytes.Length != expectedBytes.Length)
                return false;

            // CryptographicOperations.FixedTimeEquals previene los ataques de tiempo 
            // asegurando que el procesador tarde exactamente lo mismo en comparar, 
            // ya sea que falle en la primera letra o en la última[cite: 1].
            return CryptographicOperations.FixedTimeEquals(providedBytes, expectedBytes);
        }

    }
}
