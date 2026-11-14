using WebApi.DTOs.AuthenticationDto;

namespace WebApi.Mappers
{
    public static class AuthMapper
    {
        public static AuthResponseDto ToAuthResponseDto(string accessToken, string refreshToken, DateTime expiresAt, Guid accountId)
        {
            return new AuthResponseDto(
                    accessToken,
                    refreshToken,
                    expiresAt,
                    accountId
                );
        }
    }
}
