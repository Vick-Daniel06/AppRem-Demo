using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Operational
{
    public class Client
    {
        public Guid ClientId { get; private set; }
        public Guid AccountId { get; private set; }
        public int IdentificationNumber { get; private set; }
        public string ClientName { get; private set; } = string.Empty;
        public string LocationClient { get; private set; } = string.Empty;
        public DateTime UpdatedAt { get; private set; }
        public DateTime? DeletedAt { get; private set; }
        public DateTime ServerUpdateAt { get; private set; } 

        private Client() { }

        private Client(Guid clientId, Guid accountId, int identificationNumber, string clientName,
                       string locationClient, DateTime updatedAt)
        {
            ClientId = clientId;
            AccountId = accountId;
            IdentificationNumber = identificationNumber;
            ClientName = clientName;
            LocationClient = locationClient;
            UpdatedAt = updatedAt;
            ServerUpdateAt = DateTime.UtcNow; // Initialize ServerUpdateAt to the current UTC time
        }

        public static Result<Client> Create(Guid clientId, Guid accountId, int identificationNumber,
                                            string clientName, string locationClient, DateTime updatedAt)
        {
            var client = new Client(clientId, accountId, identificationNumber, clientName, locationClient, updatedAt);
            return Result<Client>.Success(client);
        }

        public Result<bool> UpdateInfo(string clientName, string locationClient, DateTime updatedAt)
        {
            ClientName = clientName;
            LocationClient = locationClient;
            UpdatedAt = updatedAt;
            ServerUpdateAt = DateTime.UtcNow;

            return Result<bool>.Success(true);
        }
        public Result<bool> MarkAsDeleted(DateTime deletedAt)
        {
            if (DeletedAt.HasValue)
                return Result<bool>.Failure("El cliente ya se encuentra eliminado.");

            DeletedAt = deletedAt;
            ServerUpdateAt = DateTime.UtcNow;

            return Result<bool>.Success(true);
        }
    }
}

