using AppRem.Domain.Entities.Operational;
using AppRem.Domain.Entities.Security;
using AppRem.Domain.Enums;
using WebApi.DTOs.SynchronizationDto;

namespace WebApi.Mappers
{
    public static class SyncMapper
    {
        //Mapper DTOs to Entity
        public static List<Product> ToProductEntities(IEnumerable<ProductSyncDto> dtos, Guid accountId)
        {
            var products = new List<Product>();
            foreach (var dto in dtos)
            {
                //string to Enum
                //Ignore case
                if (!Enum.TryParse<SalesMethod>(dto.SaleMethod, true, out var parsedSaleMethod))
                {
                    parsedSaleMethod = SalesMethod.Unidad;
                }
                //Factory Method of entity
                var result = Product.Create(
                        dto.ProductId,
                        accountId,
                        dto.IdentificationNumber,
                        dto.Name,
                        parsedSaleMethod,
                        dto.WeightKg,
                        dto.SuggestedPrice,
                        dto.Description,
                        dto.UpdatedAt
                        
                    );
                if (result.IsSuccess)
                {
                    var productEntity = result.Value!;
                    //Delete offline
                    if (dto.DeletedAt.HasValue)
                    {
                        productEntity.MarkAsDeleted(dto.DeletedAt.Value);
                    }

                    products.Add(productEntity);
                }
                    
            }
            return products;
        }

        public static List<Client> ToClientEntities(IEnumerable<ClientSyncDto> dtos, Guid accountId)
        {
            var clients = new List<Client>();
            foreach (var dto in dtos)
            {
                var result = Client.Create(
                    dto.ClientId,
                    accountId,
                    dto.IdentificationNumber,
                    dto.ClientName,
                    dto.LocationClient,
                    dto.UpdatedAt
                    );
                if (result.IsSuccess)
                {
                    var clientEntity = result.Value!;
                    if (dto.DeletedAt.HasValue)
                    {
                        clientEntity.MarkAsDeleted(dto.DeletedAt.Value);
                    }
                    clients.Add(clientEntity);
                }
            }
            return clients;
        }
        public static List<Remission> ToRemissionEntities(IEnumerable<RemissionSyncDto> dtos, Guid accountId)
        {
            var remissions = new List<Remission>();
            foreach (var dto in dtos)
            {
                //Mapper the remission to Entity
                var remissionResult = Remission.Create(
                    dto.RemissionId,
                    dto.ClientId,
                    accountId, 
                    dto.Folio,
                    dto.CreationDate,
                    dto.CompanyNameSnapshot,
                    dto.ClientNameSnapshot,
                    dto.ClientSignaturePath, 
                    dto.UserSignaturePath, 
                    dto.CompanyPhotoPath,
                    dto.FotoEvidenciaPath,
                    dto.UpdatedAt
                );

                if (remissionResult.IsSuccess)
                {
                    var remissionEntity = remissionResult.Value!;

                    foreach (var detailDto in dto.Details)
                    {

                        var detailResult = DetailLine.Create(
                            detailDto.DetailLineId,
                            dto.RemissionId,
                            detailDto.ProductId,
                            accountId,
                            detailDto.ProductNameSnapshot,
                            detailDto.Amount,
                            detailDto.OriginalSuggestedPrice,
                            detailDto.UnitPriceAtThatTime,
                            detailDto.Description
                        );
                        
                        if (detailResult.IsSuccess) 
                        {
                            remissionEntity.AddDetailLine(detailResult.Value!);
                        }
                    }

                    remissions.Add(remissionEntity);
                }
            }
            return remissions;
        }
        public static User? ToUserEntity(UserSyncDto? dto, Guid userId, Guid accountId)
        {
            if (dto == null)
                return null;

            var result = User.Create(
                    userId,
                    accountId,
                    dto.UserName,
                    null,
                    dto.UserSignatureUrl,
                    DateTime.UtcNow,
                    dto.UpdatedAt
                );
            return result.IsSuccess ? result.Value : null;
        }
        public static UserSyncDto ToUserDto(User user)
        {
            if (user == null)
                return null;

            var result = new UserSyncDto(
                    //user.UserId,
                    user.UserName,
                    user.UserSignatureUrl,
                    DateTime.UtcNow
                );
            return result;
        }
        public static List<ProductSyncDto> ToProductDtos(IEnumerable<Product> entities)
        {
            var dtos = new List<ProductSyncDto>();
            foreach (var entity in entities)
            {
                dtos.Add(new ProductSyncDto(
                    entity.ProductId,
                    entity.IdentificationNumber,
                    entity.Name,
                    entity.SaleMethod.ToString(), 
                    entity.WeightKg,
                    entity.SuggestedPrice,
                    entity.Description,
                    entity.UpdatedAt,
                    entity.DeletedAt
                ));
            }
            return dtos;
        }

        public static List<ClientSyncDto> ToClientDtos(IEnumerable<Client> entities)
        {
            var dtos = new List<ClientSyncDto>();
            foreach (var entity in entities)
            {
                dtos.Add(new ClientSyncDto(
                    entity.ClientId,
                    entity.IdentificationNumber,
                    entity.ClientName,
                    entity.LocationClient,
                    entity.UpdatedAt,
                    entity.DeletedAt
                ));
            }
            return dtos;
        }

        public static List<RemissionSyncDto> ToRemissionDtos(IEnumerable<Remission> entities)
        {
            var dtos = new List<RemissionSyncDto>();
            foreach (var entity in entities)
            {
                var detailDtos = new List<DetailLineSyncDto>();

                foreach (var detail in entity.Details)
                {
                    detailDtos.Add(new DetailLineSyncDto(
                        detail.DetailLineId,
                        detail.RemissionId,
                        detail.ProductId,
                        detail.ProductNameSnapshot,
                        detail.Amount,
                        detail.OriginalSuggestedPrice,
                        detail.UnitPriceAtThatTime,
                        detail.SubTotal,
                        detail.Description
                    ));
                }

                dtos.Add(new RemissionSyncDto(
                    entity.RemissionId,
                    entity.ClientId,
                    entity.Folio,
                    entity.CreationDate,
                    entity.CompanyNameSnapshot,
                    entity.ClientNameSnapshot,
                    entity.TotalAmount,
                    entity.ClientSignaturePath,
                    entity.UserSignaturePath!,
                    entity.CompanyPhotoPath,
                    entity.FotoEvidenciaPath,
                    entity.UpdatedAt,
                    detailDtos
                ));
            }
            return dtos;
        }
    }

}
