using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Operational
{
    public class DetailLine
    {
        public Guid DetailLineId { get; private set; }
        public Guid RemissionId { get; private set; }
        public Guid ProductId { get; private set; }
        public Guid AccountId { get; private set; }
        public string ProductNameSnapshot { get; private set; } = string.Empty;
        public decimal Amount { get; private set; }
        public decimal OriginalSuggestedPrice { get; private set; }
        public decimal UnitPriceAtThatTime { get; private set; }
        public decimal SubTotal { get; private set; }
        public string? Description { get; private set; }

        private DetailLine() { }

        private DetailLine(Guid detailLineId, Guid remissionId, Guid productId, Guid accountId,
                           string productNameSnapshot, decimal amount, decimal originalSuggestedPrice,
                           decimal unitPriceAtThatTime, string? description)
        {
            DetailLineId = detailLineId;
            RemissionId = remissionId;
            ProductId = productId;
            AccountId = accountId;
            ProductNameSnapshot = productNameSnapshot;
            Amount = amount;
            OriginalSuggestedPrice = originalSuggestedPrice;
            UnitPriceAtThatTime = unitPriceAtThatTime;
            Description = description;

            SubTotal = amount * unitPriceAtThatTime;
        }

        public static Result<DetailLine> Create(Guid detailLineId, Guid remissionId, Guid productId,
                                                Guid accountId, string productNameSnapshot, decimal amount,
                                                decimal originalSuggestedPrice, decimal unitPriceAtThatTime,
                                                string? description)
        {
            if (amount <= 0)
                return Result<DetailLine>.Failure("La cantidad o peso debe ser mayor a cero.");

            if (unitPriceAtThatTime < 0)
                return Result<DetailLine>.Failure("El precio unitario no puede ser negativo.");

            var line = new DetailLine(detailLineId, remissionId, productId, accountId, productNameSnapshot,
                                      amount, originalSuggestedPrice, unitPriceAtThatTime, description);

            return Result<DetailLine>.Success(line);
        }
        public void UpdateLine(decimal amount, decimal originalSuggestedPrice, decimal unitPriceAtThatTime, string? description)
        {
            Amount = amount;
            OriginalSuggestedPrice = originalSuggestedPrice;
            UnitPriceAtThatTime = unitPriceAtThatTime;
            //Only Sever can caculate subtotal
            SubTotal = amount * unitPriceAtThatTime;

            Description = description;

        }
    }
}
