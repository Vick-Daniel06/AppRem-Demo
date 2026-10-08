using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Operational
{
    public class Remission
    {
        public Guid RemissionId { get; set; }
        public Guid ClientId { get; set; }
        public Guid AccountId { get; set; }
        public string Folio { get; set; } = string.Empty;
        public DateTime CreationDate { get; set; }
        public string CompanyNameSnapshot { get; set; } = string.Empty;
        public string ClientNameSnapshot { get; set; } = string.Empty;
        public decimal TotalAmount { get; set; }
        public string ClientSignaturePath { get; set; } = string.Empty;
        public string? UserSignaturePath { get; set; }
        public string? CompanyPhotoPath { get; set; }
        public string? FotoEvidenciaPath { get; set; }
        public DateTime UpdatedAt { get; set; }
        public DateTime ServerUpdateAt { get; set; }
        public List<DetailLine> DetailLines { get; set; } = new();
    }
}
