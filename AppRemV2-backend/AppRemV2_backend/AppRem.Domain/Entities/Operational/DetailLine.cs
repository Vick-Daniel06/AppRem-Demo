using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Operational
{
    public class DetailLine
    {
        public Guid DetailLineId { get; set; }
        public Guid RemissionId { get; set; }
        public Guid ProductId { get; set; }
        public Guid AccountId { get; set; }
        public string ProductNameSnapshot { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public decimal OriginalSuggestedPrice { get; set; }
        public decimal UnitPriceAtThatTime { get; set; }
        public decimal SubTotal { get; set; } // amount * unitPriceAtThatTime[cite: 2]
        public string? Description { get; set; }
    }
}
