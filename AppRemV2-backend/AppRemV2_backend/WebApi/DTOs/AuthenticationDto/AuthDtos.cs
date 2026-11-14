using System.ComponentModel.DataAnnotations;

namespace WebApi.DTOs.AuthenticationDto
{
    //the server receives when it attempts to log in
    public record PromoteAccountDto(

        [Required] Guid LocalUserId,
        [Required] Guid LocalAccountId,
        [Required] string Provider,
        [Required] string IdToken

    );

    //returns the server response if the promotion/login was successful
    public record AuthResponseDto(
            string AccessToken,
            string RefreshToken,
            DateTime ExpiresAt,
            Guid AccountId // the Cloud Id official.
        );

    public record RefreshTokenRequestDto(
        [Required]string ExpiredAccessToken, 
        string RefreshToken);
}
