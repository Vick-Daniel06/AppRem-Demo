using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Security
{
    public class Account
    {
        public Guid AccountId { get; private set; }
        public string? CompanyName { get; private set; }
        public string? CompanyLogoUrl { get; private set; }
        public bool IsSubscribed { get; private set; }
        public DateTime? SubscriptionExpiration { get; private set; }
        public DateTime CreatedAt { get; private set; }
        public DateTime UpdatedAt { get; private set; }
        public DateTime ServerUpdateAt { get; private set; }

        private Account() { }

        private Account(Guid accountId, DateTime createdAt)
        {
            AccountId = accountId;
            CreatedAt = createdAt;
            UpdatedAt = createdAt;
            ServerUpdateAt = DateTime.UtcNow;
            IsSubscribed = false; 
        }

        public static Result<Account> Create(Guid accountId, DateTime createdAt)
        {
            return Result<Account>.Success(new Account(accountId, createdAt));
        }

        // REGLA DE NEGOCIO: Activado por el Webhook de RevenueCat (Pago Exitoso)
        public Result<bool> ActivateSubscription(DateTime expirationDate)
        {
            if (expirationDate <= DateTime.UtcNow)
                return Result<bool>.Failure("La fecha de expiración proporcionada ya venció.");

            IsSubscribed = true;
            SubscriptionExpiration = expirationDate;
            ServerUpdateAt = DateTime.UtcNow;

            return Result<bool>.Success(true);
        }

        // REGLA DE NEGOCIO: Activado por el Webhook de RevenueCat (Rebote o Cancelación)
        public Result<bool> FreezeAccount()
        {
            IsSubscribed = false;
            // No borramos los datos, solo bajamos la bandera para bloquear nuevas subidas
            ServerUpdateAt = DateTime.UtcNow;

            return Result<bool>.Success(true);
        }

        public Result<bool> UpdateProfile(string? companyName, string? companyLogoUrl)
        {
            CompanyName = companyName;
            CompanyLogoUrl = companyLogoUrl;
            UpdatedAt = DateTime.UtcNow;
            ServerUpdateAt = DateTime.UtcNow;

            return Result<bool>.Success(true);
        }
    }
}
