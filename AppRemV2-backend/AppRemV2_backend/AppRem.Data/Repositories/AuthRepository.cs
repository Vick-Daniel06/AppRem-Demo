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
    public class AuthRepository : IAuthRepository
    {
        private readonly AppDbContext _context;
        public AuthRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Result<Account>> PromoteAccountAsync(Guid localAccountId, Guid localUserId, string provider, string providerUid, string? email) {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                //check if providerUid exists
                var existingIdentity = await _context.Identities
                    .FirstOrDefaultAsync(i => i.Provider == provider && i.ProviderUid == providerUid);
                if (existingIdentity != null)
                {
                    //RULE: If alredy exists, return the accountId vinculated and ignore de localAccountId
                    var existingAccount = await _context.Accounts.FindAsync(existingIdentity.AccountId);
                    return Result<Account>.Success(existingAccount!);
                }

                // IF IT DOESN'T EXIST: We proceed to "promote" the local UUID v7s that Flutter generated on Day 1.
                var account = await _context.Accounts.FindAsync(localAccountId);
                if(account != null)
                    return Result<Account>.Failure("The local account already exists, cannot promote.");

                if (account == null)
                {
                    var accountResult = Account.Create(localAccountId, DateTime.UtcNow);
                    if (!accountResult.IsSuccess)
                        return Result<Account>.Failure("Failed to create account.");

                    account = accountResult.Value!;
                    await _context.Accounts.AddAsync(account);
                }

                var user = await _context.Users.FindAsync(localUserId);
                if(user != null)
                    return Result<Account>.Failure("The local user already exists, cannot promote.");

                if (user == null)
                {
                    var userResult = User.Create(localUserId, localAccountId, null, email, null, DateTime.UtcNow, DateTime.UtcNow);
                    if (!userResult.IsSuccess)
                        return Result<Account>.Failure("Failed to create user.");

                    user = userResult.Value!;
                    await _context.Users.AddAsync(user);
                }

                var identityResult = Identity.Create(Guid.NewGuid(), localAccountId, localUserId, provider, providerUid, email, true, DateTime.UtcNow);
                if (!identityResult.IsSuccess)
                    return Result<Account>.Failure(identityResult.ErrorMessage!);

                await _context.Identities.AddAsync(identityResult.Value!);
                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return Result<Account>.Success(account);
            }
            catch (Exception ex) { 
                await transaction.RollbackAsync();
                return Result<Account>.Failure($"Error al promover cuenta: {ex.Message}");
            }
        }

        public async Task<Result<Identity>> GetIdentityByProviderUidAsync(string provider, string providerUid)
        {
            try
            {
               
                var identity = await _context.Identities
                    .FirstOrDefaultAsync(i => i.Provider == provider && i.ProviderUid == providerUid);

                return identity != null
                    ? Result<Identity>.Success(identity)
                    : Result<Identity>.Failure("Identidad no encontrada.");
            }
            catch (Exception ex)
            {
                return Result<Identity>.Failure($"Error BD al buscar identidad: {ex.Message}");
            }
        }

        public async Task<Result<Account>> GetAccountByIdAsync(Guid accountId)
        {
            try
            {
            
                var account = await _context.Accounts.FindAsync(accountId);

                return account != null
                    ? Result<Account>.Success(account)
                    : Result<Account>.Failure("Cuenta no encontrada.");
            }
            catch (Exception ex)
            {
                return Result<Account>.Failure($"Error BD al buscar cuenta: {ex.Message}");
            }
        }

        public async Task<Result<User>> GetUserByIdAsync(Guid userId)
        {
            try
            {
               
                var user = await _context.Users.FindAsync(userId);

                return user != null
                    ? Result<User>.Success(user)
                    : Result<User>.Failure("Usuario no encontrado.");
            }
            catch (Exception ex)
            {
                return Result<User>.Failure($"Error BD al buscar usuario: {ex.Message}");
            }
        }
        //Gestion of tokens
        public async Task<Result<bool>> SaveRefreshTokenAsync(RefreshToken refreshToken)
        { 
            await _context.RefreshTokens.AddAsync(refreshToken);
            await _context.SaveChangesAsync();
            return Result<bool>.Success(true);
        }
        public async Task<Result<RefreshToken>> GetRefreshTokenAsync(Guid userId, string tokenHash)
        {
            try
            {
                // El minero solo extrae el dato crudo
                var token = await _context.RefreshTokens
                    .FirstOrDefaultAsync(rt => rt.UserId == userId && rt.TokenHash == tokenHash);

                return token != null
                    ? Result<RefreshToken>.Success(token)
                    : Result<RefreshToken>.Failure("Token no encontrado.");
            }
            catch (Exception ex)
            {
                return Result<RefreshToken>.Failure($"Error BD: {ex.Message}");
            }
        }
        public async Task<Result<bool>> UpdateRefreshTokenAsync(RefreshToken refreshToken)
        {
            try
            {
                _context.RefreshTokens.Update(refreshToken);
                await _context.SaveChangesAsync();
                return Result<bool>.Success(true);
            }
            catch (Exception ex)
            {
                return Result<bool>.Failure($"Error al actualizar el refresh token: {ex.Message}");
            }
        }

    }
}

