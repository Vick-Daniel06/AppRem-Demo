using System.Text.Json.Serialization;

namespace WebApi.DTOs.WebHook
{
    //The object that the controller recibe
    public record RevenueCatWebhookDto(
           //JsonPropertyName to enlace the JSON of the RevenueCat in snake_case
           [property: JsonPropertyName("event")] RevenueCatEvent Event
        );
    //The estrcutre of the event
    public record RevenueCatEvent(
            [property: JsonPropertyName("type")]string Type,
            [property: JsonPropertyName("store")]string Store,
            [property: JsonPropertyName("app_user_id")]string AppUserId,
            [property: JsonPropertyName("product_id")]string ProductId,// ej: "apprem_monthly_20"
            [property: JsonPropertyName("purchased_at_ms")]long? PurchasedAtMs,
            [property: JsonPropertyName("expiration_at_ms")] long? ExpirationAtMs,
            [property: JsonPropertyName("transaction_id")] string TransactionId 
        );

}
