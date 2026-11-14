using System.ComponentModel.DataAnnotations;

namespace WebApi.DTOs.SynchronizationDto
{
    public record ProductSyncDto(
        [Required] Guid ProductId,
        [Required] int IdentificationNumber,
        [Required] string Name,
        [Required] string SaleMethod,
        double? WeightKg,
        [Required] decimal SuggestedPrice,
        string? Description,
        [Required] DateTime UpdatedAt,
        DateTime? DeletedAt
        );
    public record ClientSyncDto(
        [Required] Guid ClientId,
        [Required] int IdentificationNumber,
        [Required] string ClientName,
        [Required] string LocationClient,
        [Required] DateTime UpdatedAt,
        DateTime? DeletedAt
    );

    public record DetailLineSyncDto(
        [Required] Guid DetailLineId,
        [Required] Guid RemissionId,
        [Required] Guid ProductId,
        [Required] string ProductNameSnapshot,
        [Required] decimal Amount,
        [Required] decimal OriginalSuggestedPrice,
        [Required] decimal UnitPriceAtThatTime,
        [Required] decimal SubTotal,
        string? Description
    );

    public record RemissionSyncDto(
        [Required] Guid RemissionId,
        [Required] Guid ClientId,
        [Required] string Folio,
        [Required] DateTime CreationDate,
        [Required] string CompanyNameSnapshot,
        [Required] string ClientNameSnapshot,
        [Required] decimal TotalAmount,
        //URL Azure
        [Required] string ClientSignaturePath,
        [Required] string UserSignaturePath,
        string? CompanyPhotoPath,
        string? FotoEvidenciaPath,
        [Required] DateTime UpdatedAt,
        [Required] List<DetailLineSyncDto> Details
        );
    public record UserSyncDto(
        //This UserId is not the Id that is in the database, it is the Id that is in the device
        //Guid userId,
        string? UserName,
        string? UserSignatureUrl,
        [Required] DateTime UpdatedAt
        );
    //The incoming packet—the trigger that occurs upon detecting an Internet connection
    public record SyncPushRequestDto(
        UserSyncDto? User,
        List<ProductSyncDto> Products,
        List<ClientSyncDto> Clients,
        List<RemissionSyncDto> Remissions
    );

    //The output responses
    //Response for when data is uploaded (Push).
    public record SyncPushResponseDto(
        List<Guid> ProcessedProductIds,
        List<Guid> ProcessedClientIds,
        List<Guid> ProcessedRemissionIds,
        DateTime SyncedAt
    );
    //Response for when data is downloaded (Pull).
    public record SyncPullResponseDto(
        List<ProductSyncDto> Products,
        List<ClientSyncDto> Clients,
        List<RemissionSyncDto> Remissions,
        DateTime ServerTimestamp
    );

}
