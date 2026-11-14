

using AppRem.Domain.Core;
using AppRem.Domain.Entities.Security;

namespace AppRem.Domain.Interface
{
    public interface IAuthRepository
    {
        //Promove the local account to vinculate with the ID of Google/Apple
        Task<Result<Account>> PromoteAccountAsync (Guid localAccountId, Guid localUserId, string provider, string providerUid, string? email);
        // Checks if a provider (Google/Apple) is already linked to an account
        Task<Result<Identity>> GetIdentityByProviderUidAsync(string provider, string providerUid);

        Task<Result<Account>> GetAccountByIdAsync(Guid accountId);
        Task<Result<User>> GetUserByIdAsync(Guid userId);
        //session management
        Task<Result<bool>> SaveRefreshTokenAsync(RefreshToken refreshToken);
        Task<Result<RefreshToken>> GetRefreshTokenAsync(Guid userId, string tokenHash);
        Task<Result<bool>> UpdateRefreshTokenAsync(RefreshToken refreshToken);


    }
}
