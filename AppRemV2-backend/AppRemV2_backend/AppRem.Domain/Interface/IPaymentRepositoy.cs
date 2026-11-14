using AppRem.Domain.Core;
using AppRem.Domain.Entities.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Interface
{
    public interface IPaymentRepository
    {
        //Records the immutable accounting log from RevenueCat.
        Task<Result<bool>> SavePurchaseLogAsync(PurchasesLog log);
        //Updates the account subscription status based on webhook
        Task<Result<bool>> UpdateAccountSubscriptionAsync(Account account);
        //Check the database to see if the receipt has already been processed (anti-replay)
        Task<Result<bool>> IsPurchaseTokenUniqueAsync(string purchaseToken);
    }
}
