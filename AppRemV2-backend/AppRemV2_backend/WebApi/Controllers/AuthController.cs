
using AppRem.Domain.Entities.Security;
using AppRem.Domain.Interface;
using AppRem.Domain.UseCase;
using Azure.Core;
using Google.Apis.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.Identity.Client;
using System.Security.Claims;
using WebApi.DTOs.AuthenticationDto;
using WebApi.Mappers;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [EnableRateLimiting("AuthPolicy")]
    public class AuthController : ControllerBase
    {
        private readonly AuthUseCase _authUseCase;
        private readonly IJwtTokenGenerator _jwtTokenGenerator;
        private readonly IConfiguration _configuration;
        public AuthController(AuthUseCase authUseCase,IJwtTokenGenerator jwtTokenGenerator, IConfiguration configuration)
        {
            _authUseCase = authUseCase;
            _jwtTokenGenerator = jwtTokenGenerator;
            _configuration = configuration;
        }

        //Promote a local account to the cloud
        [HttpPost("promote")]
        [AllowAnonymous]
        public async Task<IActionResult> PromoteAccount([FromBody] PromoteAccountDto request)
        {
            if (request.LocalAccountId == Guid.Empty || request.LocalUserId == Guid.Empty)
                return BadRequest("Invalid local identifiers.");

            string providerUid;
            string email;
         

            try
            {
                if (request.Provider.Equals("google", StringComparison.OrdinalIgnoreCase))
                {

                    var googleClientId = _configuration["Authentication:GoogleClientId"];
                    if (string.IsNullOrWhiteSpace(googleClientId))
                        return StatusCode(500, "Configuration error on the authentication server.");

                    //We use the official Google library to validate the signature and validity of the IdToken.
                    var settings = new GoogleJsonWebSignature.ValidationSettings
                    {
                        Audience = new[] { googleClientId }
                    };
                    var payload = await GoogleJsonWebSignature.ValidateAsync(request.IdToken, settings);
                    if (!payload.EmailVerified)
                        return Unauthorized("The Google account must have a verified email address.");

                    //sub, the Id
                    providerUid = payload.Subject;
                    email = payload.Email;
                    
                }
                else if (request.Provider.Equals("apple", StringComparison.OrdinalIgnoreCase))
                {
                   
                    return BadRequest("Sign in with Apple setup is pending.");
                }
                else
                {
                    return BadRequest("Identity provider not supported.");
                }
            }
            catch (InvalidJwtException)
            {
                //if the token is fake or expired
                return Unauthorized("The provided identity token is invalid or has expired");
            }
            catch (Exception)
            {
                return StatusCode(500, "Identity could not be verified with the third-party provider.");
            }

            var result = await _authUseCase.LoginOrPromoteAccountAsync(
                    request.LocalAccountId,
                    request.LocalUserId,
                    request.Provider.ToLowerInvariant(),
                    providerUid,
                    email
                );
            if (!result.IsSuccess)
                return BadRequest(result.ErrorMessage);

            //Package the response using the Mapper
            var (accessToken, refreshToken, expiresAt, accountId) = result.Value;
            var responseDto = AuthMapper.ToAuthResponseDto(accessToken, refreshToken, expiresAt, accountId);
            return Ok(responseDto);
        }
        //Renew the short-lived AccessToken
        [HttpPost("refresh")]
        [AllowAnonymous]
        public async Task<IActionResult> RefreshSession([FromBody] RefreshTokenRequestDto requestDto)
        {
            var principalResult = _jwtTokenGenerator.GetPrincipalFromExpiredToken(requestDto.ExpiredAccessToken);
            if (!principalResult.IsSuccess)
                return Unauthorized("Access token inválido o alterado.");

            var userIdClaim = principalResult.Value!.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!Guid.TryParse(userIdClaim, out Guid userId))
                return Unauthorized("Token corrupto.");

            var result = await _authUseCase.RefreshSessionAsync(userId, requestDto.RefreshToken);

            if (!result.IsSuccess)
                return Unauthorized(result.ErrorMessage);

            var (newAccessToken, newRefreshToken, expiresAt, accountId) = result.Value;
            return Ok(AuthMapper.ToAuthResponseDto(newAccessToken, newRefreshToken, expiresAt, accountId));

        }

#if DEBUG
        [HttpPost("dev-promote")]
        [AllowAnonymous]
        public async Task<IActionResult> DevPromoteAccount([FromBody] PromoteAccountDto request)
        {
            // Simula que Google ya validó el token y nos devolvió un UID y correo de prueba
            var fakeGoogleUid = $"dev_uid_{request.LocalUserId}";
            var fakeEmail = "tester@apprem.local";
            var result = await _authUseCase.LoginOrPromoteAccountAsync(
                request.LocalAccountId,
                request.LocalUserId,
                "google",
                fakeGoogleUid,
                fakeEmail
            );
            if (!result.IsSuccess)
                return BadRequest(result.ErrorMessage);
            var (accessToken, refreshToken, expiresAt, accountId) = result.Value;
            return Ok(AuthMapper.ToAuthResponseDto(accessToken, refreshToken, expiresAt, accountId));
        }
#endif
    }
}
