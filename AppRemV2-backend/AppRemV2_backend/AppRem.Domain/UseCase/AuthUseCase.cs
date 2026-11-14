using AppRem.Domain.Core;
using AppRem.Domain.Entities.Security;
using AppRem.Domain.Interface;
using System.Security.Cryptography;
using System.Text;

namespace AppRem.Domain.UseCase
{
    public class AuthUseCase
    {
        private readonly IAuthRepository _authRepository;
        private readonly IJwtTokenGenerator _jwtTokenGenerator;

        public AuthUseCase(IAuthRepository authRepository, IJwtTokenGenerator jwtTokenGenerator)
        {
            _authRepository = authRepository;
            _jwtTokenGenerator = jwtTokenGenerator;
            
        }
        public async Task<Result<(string AccessToken, string RefreshToken, DateTime ExpiresAt, Guid AccountId)>> LoginOrPromoteAccountAsync(
            Guid localAccountId, Guid localUserId, string provider, string providerUid, string? email)
        {
            //Check whether the `providerUid` already exists; if it does, return the existing account; otherwise, promote the local UUIDs to the cloud.
            var accountResult = await _authRepository.PromoteAccountAsync(localAccountId, localUserId, provider, providerUid, email);
            if (!accountResult.IsSuccess)
                return Result<(string, string, DateTime, Guid)>.Failure(accountResult.ErrorMessage!);

            var account = accountResult.Value!;
            //Get the real user
            
            var identityResult = await _authRepository.GetIdentityByProviderUidAsync(provider, providerUid);
            if (!identityResult.IsSuccess)
                return Result<(string, string, DateTime, Guid)>.Failure("Identity not found after promotion.");

            var userResult = await _authRepository.GetUserByIdAsync(identityResult.Value!.UserId);
            if (!userResult.IsSuccess)
                return Result<(string, string, DateTime, Guid)>.Failure(userResult.ErrorMessage!);

            var user = userResult.Value!;

            //Tokens generate
            var accessToken = _jwtTokenGenerator.GenerateAccessTokens(user, account);
            var rawRefreshToken = _jwtTokenGenerator.GenerateRefreshToken();
            var expiresAt = DateTime.UtcNow.AddDays(7);

            //Refresh Token Encryption
            var tokenHash = HashToken(rawRefreshToken);
            var refreshTokenEntityResult = RefreshToken.Create(user.UserId, tokenHash, expiresAt);

            if (!refreshTokenEntityResult.IsSuccess)
                return Result<(string, string, DateTime, Guid)>.Failure(refreshTokenEntityResult.ErrorMessage!);

            var saveResult = await _authRepository.SaveRefreshTokenAsync(refreshTokenEntityResult.Value!);
            if (!saveResult.IsSuccess)
                return Result<(string, string, DateTime, Guid)>.Failure(saveResult.ErrorMessage!);

            /*Return the official AccountId; if the framework detects that the ID differs from its local UUID v7,
             it will overwrite its database.
             */
            return Result<(string, string, DateTime, Guid)>.Success(
                (accessToken, rawRefreshToken, expiresAt, account.AccountId)
                );

        }
        //Renew the access token
        public async Task<Result<(string AccessToken, string RefreshToken, DateTime ExpiresAt, Guid accountId)>> RefreshSessionAsync(
            Guid userId, string rawRefreshToken)
        {
            var tokenHash = HashToken(rawRefreshToken);

            var tokenResult = await _authRepository.GetRefreshTokenAsync(userId, tokenHash);
            if (!tokenResult.IsSuccess)
                return Result<(string, string, DateTime, Guid)>.Failure(tokenResult.ErrorMessage!);

            var refreshToken = tokenResult.Value!;

            //expiration and revocation rules
            var validationResult = refreshToken.Validate();
            if (!validationResult.IsSuccess)
                return Result<(string, string, DateTime,Guid)>.Failure(validationResult.ErrorMessage!);

            //revocation
            refreshToken.Revoke();
            await _authRepository.UpdateRefreshTokenAsync(refreshToken);

            var userResult = await _authRepository.GetUserByIdAsync(userId);
            if (!userResult.IsSuccess)
                return Result<(string, string, DateTime, Guid)>.Failure("User not found");


            var accountResult = await _authRepository.GetAccountByIdAsync(userResult.Value!.AccountId);
            if (!accountResult.IsSuccess)
                return Result<(string, string, DateTime, Guid)>.Failure("Account not found");

            //start a new session
            var newAccessToken = _jwtTokenGenerator.GenerateAccessTokens(userResult.Value!, accountResult.Value!);
            var newRawRefreshToken = _jwtTokenGenerator.GenerateRefreshToken();
            var expiresAt = DateTime.UtcNow.AddDays(7);

            var newHash = HashToken(newRawRefreshToken);
            var newRefreshTokenEntityResult = RefreshToken.Create(userId, newHash, expiresAt);

            await _authRepository.SaveRefreshTokenAsync(newRefreshTokenEntityResult.Value!);
            return Result<(string, string, DateTime, Guid)>.Success((newAccessToken, newRawRefreshToken, expiresAt, accountResult.Value!.AccountId));
        }

        private string HashToken(string token)
        {
            using var sha256 = SHA256.Create();
            var bytes = Encoding.UTF8.GetBytes(token);
            var hash = sha256.ComputeHash(bytes);
            return Convert.ToBase64String(hash);
        }

    }
}
