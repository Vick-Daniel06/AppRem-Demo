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
        public Guid ProductId { get; set; }
        public Guid AccountId { get; set; }
        public int IdentificationNumber { get; set; }
        public string Name { get; set; } = string.Empty;
        public SalesMethod SaleMethod { get; set; } = SalesMethod.Unidad;
        public double? WeightKg { get; set; }
        public decimal SuggestedPrice { get; set; }
        public string? Description { get; set; }
        public DateTime UpdatedAt { get; set; }
        public DateTime? DeletedAt { get; set; }
        public DateTime ServerUpdateAt { get; set; }
    }
}
