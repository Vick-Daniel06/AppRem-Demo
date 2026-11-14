using AppRem.Data.Data;
using AppRem.Domain.Core;
using AppRem.Domain.Entities.Security;
using AppRem.Domain.Interface;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Data.Repositories
{
    public class PaymentRepository : IPaymentRepository
    {
        private readonly AppDbContext _context;
        public PaymentRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Result<bool>> SavePurchaseLogAsync(PurchasesLog log)
        {
            try
            {
               
                await _context.PurchasesLogs.AddAsync(log);
                await _context.SaveChangesAsync();

                return Result<bool>.Success(true);
            }
            catch (Exception ex)
            {
                return Result<bool>.Failure($"Database error when saving the payment log: {ex.Message}");
            }
        }

        public async Task<Result<bool>> UpdateAccountSubscriptionAsync(Account account)
        {
            try
            {
               
                _context.Accounts.Update(account);
                await _context.SaveChangesAsync();

                return Result<bool>.Success(true);
            }
            catch (Exception ex)
            {
                return Result<bool>.Failure($"Database error when updating the account: {ex.Message}");
            }
        }

        public async Task<Result<bool>> IsPurchaseTokenUniqueAsync(string purchaseToken)
        {
            try
            {
                
                var exists = await _context.PurchasesLogs
                    .AnyAsync(p => p.PurchaseToken == purchaseToken);

              
                return Result<bool>.Success(!exists);
            }
            catch (Exception ex)
            {
                return Result<bool>.Failure($"Database error when verifying the purchase token: {ex.Message}");
            }
        }
    }
}
