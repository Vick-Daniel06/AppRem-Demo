using AppRem.Domain.Core;
using AppRem.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Operational
{
    public class Product
    {
        public Guid ProductId { get; private set; }
        public Guid AccountId { get; private set; }
        public int IdentificationNumber { get; private set; }
        public string Name { get; private set; } = string.Empty;
        public SalesMethod SaleMethod { get; private set; }
        public double? WeightKg { get; private set; }
        public decimal SuggestedPrice { get; private set; }
        public string? Description { get; private set; }
        public DateTime UpdatedAt { get; private set; }
        public DateTime? DeletedAt { get; private set; }
        public DateTime ServerUpdateAt { get; private set; }

        // Constructor for Entity Framework
        private Product() { }

        // Private constructor for factory method to enforce business rules
        private Product(Guid productId, Guid accountId, int identificationNumber, string name,
                        SalesMethod saleMethod, double? weightKg, decimal suggestedPrice,
                        string? description, DateTime updatedAt)
        {
            ProductId = productId;
            AccountId = accountId;
            IdentificationNumber = identificationNumber;
            Name = name;
            SaleMethod = saleMethod;
            WeightKg = weightKg;
            SuggestedPrice = suggestedPrice;
            Description = description;
            UpdatedAt = updatedAt;
            ServerUpdateAt = DateTime.UtcNow;
        }

        // FACTORY METHOD
        public static Result<Product> Create(Guid productId, Guid accountId, int identificationNumber,
                                             string name, SalesMethod saleMethod, double? weightKg,
                                             decimal suggestedPrice, string? description, DateTime updatedAt)
        {
            if (suggestedPrice < 0)
                return Result<Product>.Failure("El precio sugerido no puede ser negativo.");

            var product = new Product(productId, accountId, identificationNumber, name,
                                      saleMethod, weightKg, suggestedPrice, description, updatedAt);

            return Result<Product>.Success(product);
        }

        public Result<bool> UpdateDetails(string name, decimal newPrice, SalesMethod saleMethod , double? weightKg,string? description, DateTime updatedAt)
        {
            
            if (newPrice < 0)
                return Result<bool>.Failure("El nuevo precio no puede ser negativo.");

            Name = name;
            SuggestedPrice = newPrice;
            SaleMethod = saleMethod;
            WeightKg = weightKg;
            Description = description;
            UpdatedAt = updatedAt;
            ServerUpdateAt = DateTime.UtcNow;

            return Result<bool>.Success(true);
        }
        public Result<bool> MarkAsDeleted(DateTime deletedAt)
        {
            if (DeletedAt.HasValue)
                return Result<bool>.Failure("El producto ya se encuentra eliminado.");

            DeletedAt = deletedAt;
            ServerUpdateAt = DateTime.UtcNow;

            return Result<bool>.Success(true);
        }
    }
}
