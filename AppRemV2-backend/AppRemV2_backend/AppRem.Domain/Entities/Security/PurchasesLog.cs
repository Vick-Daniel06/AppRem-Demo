using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Security
{
    public class PurchasesLog
    {
        public Guid PurchaseLogId { get; private set; }
        public Guid AccountId { get; private set; }
        public string Store { get; private set; } = string.Empty; // 'play_store', 'app_store'
        public string PurchaseToken { get; private set; } = string.Empty;
        public string ProductId { get; private set; } = string.Empty; // ID RevenueCat
        public string Status { get; private set; } = string.Empty; // 'active', 'expired', 'refunded'
        public DateTime ExpiresAt { get; private set; }
        public DateTime ReceivedAt { get; private set; }

        private PurchasesLog() { }

        private PurchasesLog(Guid purchaseLogId, Guid accountId, string store, string purchaseToken,
                             string productId, string status, DateTime expiresAt, DateTime receivedAt)
        {
            PurchaseLogId = purchaseLogId;
            AccountId = accountId;
            Store = store;
            PurchaseToken = purchaseToken;
            ProductId = productId;
            Status = status;
            ExpiresAt = expiresAt;
            ReceivedAt = receivedAt;
        }

        public static Result<PurchasesLog> Create(Guid accountId, string store,
                                                  string purchaseToken, string productId, string status,
                                                  DateTime expiresAt, DateTime receivedAt)
        {
           
            if (string.IsNullOrWhiteSpace(purchaseToken))
                return Result<PurchasesLog>.Failure("El token de compra es obligatorio para evitar fraudes.");

            var log = new PurchasesLog(Guid.NewGuid(), accountId, store, purchaseToken, productId,
                                       status, expiresAt, receivedAt);

            return Result<PurchasesLog>.Success(log);
        }
    }
}
