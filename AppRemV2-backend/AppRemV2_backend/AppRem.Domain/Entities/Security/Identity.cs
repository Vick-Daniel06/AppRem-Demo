using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Security
{
    public class Identity
    {
        public Guid IdentityId { get; private set; }
        public Guid AccountId { get; private set; }
        public Guid UserId { get; private set; }
        public string Provider { get; private set; } = string.Empty; // "google" o "apple"
        public string ProviderUid { get; private set; } = string.Empty; // ID 'sub' de Google/Apple
        public string? Email { get; private set; }
        public bool EmailVerified { get; private set; }
        public DateTime CreatedAt { get; private set; }

        
        private Identity() { }

        private Identity(Guid identityId, Guid accountId, Guid userId, string provider,
                         string providerUid, string? email, bool emailVerified, DateTime createdAt)
        {
            IdentityId = identityId;
            AccountId = accountId;
            UserId = userId;
            Provider = provider;
            ProviderUid = providerUid;
            Email = email;
            EmailVerified = emailVerified;
            CreatedAt = createdAt;
        }

        // FACTORY METHOD
        public static Result<Identity> Create(Guid identityId, Guid accountId, Guid userId,
                                              string provider, string providerUid, string? email,
                                              bool emailVerified, DateTime createdAt)
        {
            if (string.IsNullOrWhiteSpace(providerUid))
                return Result<Identity>.Failure("El UID del proveedor no puede estar vacío.");

            var identity = new Identity(identityId, accountId, userId, provider, providerUid,
                                        email, emailVerified, createdAt);

            return Result<Identity>.Success(identity);
        }
    }
}
