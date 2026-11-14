using WebApi.DTOs.WebHook;

namespace WebApi.Mappers
{
    public static class PaymentMapper
    {
        public static (Guid AccountId, string Store, string PurchaseToken, string ProductId, string Status, DateTime ExpiresAt)
            ExtractPaymentData(RevenueCatWebhookDto dto)
        {

            Guid.TryParse(dto.Event.AppUserId, out Guid accountId);

            return (
                accountId,
                dto.Event.Store,
                dto.Event.TransactionId,
                dto.Event.ProductId,
                dto.Event.Type, //State
                ExtractExpirationDate(dto)
            );
        }
        public static DateTime ExtractExpirationDate(RevenueCatWebhookDto dto)
        {
            long expirationMs = dto.Event.ExpirationAtMs ?? 0;
            if (expirationMs == 0)
                return DateTime.UtcNow;

            // Converts the Unix Epoch to a DateTime with a UTC time zone (Crucial for ensuring the server clock is accurate)
            return DateTimeOffset.FromUnixTimeMilliseconds(expirationMs).UtcDateTime;
        }
        public static DateTime ExtractPurchaseDate(RevenueCatWebhookDto dto)
        {
            long purchaseMs = dto.Event.PurchasedAtMs ?? 0;

            if (purchaseMs == 0)
                return DateTime.UtcNow;

            return DateTimeOffset.FromUnixTimeMilliseconds(purchaseMs).UtcDateTime;
        }
    }
}
