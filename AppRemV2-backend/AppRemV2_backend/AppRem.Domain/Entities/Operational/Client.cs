using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Operational
{
    public class Client
    {
        public Guid ClientId { get; set; }
        public Guid AccountId { get; set; }
        public int IdentificationNumber { get; set; }
        public string ClientName { get; set; } = string.Empty;
        public string LocationClient { get; set; } = string.Empty;
        public DateTime UpdatedAt { get; set; }
        public DateTime? DeletedAt { get; set; }
        public DateTime ServerUpdateAt { get; set; }
    }
}
