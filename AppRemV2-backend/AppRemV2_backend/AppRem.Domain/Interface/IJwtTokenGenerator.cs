using AppRem.Domain.Core;
using AppRem.Domain.Entities.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Interface
{
    public interface IJwtTokenGenerator
    {
        //Generates session access token by evaluating the account and the user.
        string GenerateAccessTokens(User user, Account account);
        //Generates the random cryptographic string to be used as the Refresh Token
        string GenerateRefreshToken();
        Result<ClaimsPrincipal> GetPrincipalFromExpiredToken(string token);

    }
}
