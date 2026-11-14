using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Security
{
    public class RefreshToken
    {
        public Guid RefreshTokenId { get; private set; }
        public Guid UserId { get; private set; }
        public string TokenHash { get; private set; } = string.Empty;
        public DateTime Expired { get; private set; }
        public bool IsRevoked { get; private set; }

        private RefreshToken() { }

        private RefreshToken(Guid refreshTokenId, Guid userId, string tokenHash, DateTime expired)
        {
            RefreshTokenId = refreshTokenId;
            UserId = userId;
            TokenHash = tokenHash;
            Expired = expired;
            IsRevoked = false; 
        }

        public static Result<RefreshToken> Create( Guid userId, string tokenHash, DateTime expired)
        {
            var refreshToken = new RefreshToken(Guid.NewGuid(), userId, tokenHash, expired);
            return Result<RefreshToken>.Success(refreshToken);
        }

        // Method to revoke the refresh token: to prevent its further use
        public Result<bool> Validate()
        {
            if (IsRevoked) return Result<bool>.Failure("Esta sesión ha sido revocada por seguridad.");
            if (Expired < DateTime.UtcNow) return Result<bool>.Failure("La sesión ha expirado.");

            return Result<bool>.Success(true);
        }

        public void Revoke()
        {
            IsRevoked = true;
        }
    }
}
