
using AppRem.Domain.Interface;
using AppRem.Domain.UseCase;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using WebApi.DTOs.SynchronizationDto;
using WebApi.Mappers;
using Microsoft.AspNetCore.RateLimiting;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    [EnableRateLimiting("SyncPolicy")] //Protect /push, /pull, and /upload by AccountId
    public class SyncController : ControllerBase
    {
        private readonly ISyncUseCase _syncUseCase;
        public SyncController(ISyncUseCase syncUseCase)
        {
            _syncUseCase = syncUseCase;
        }

        [HttpPost("upload")]
        [RequestSizeLimit(1_048_576)]// Maximum 1 MB per image/signature
        public async Task<IActionResult> UploadFile(IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest("No file was provided.");

            var accountIdClaim = User.FindFirstValue("accountId");
            if (!Guid.TryParse(accountIdClaim, out Guid accountId))
                return Unauthorized("Invalid token");

            using var strem = file.OpenReadStream();
            var result = await _syncUseCase.UploadFileAsync(accountId, strem, file.ContentType);

            if (!result.IsSuccess)
                return BadRequest(result.ErrorMessage);

            return Ok(new { url = result.Value });

        }
        //Receives the batch of records created/modified offline.
        [HttpPost("push")]
        [RequestSizeLimit(5_242_880)]// Maximum 5 MB for the synchronization batch JSON
        public async Task<IActionResult> Push([FromBody] SyncPushRequestDto requestDto)
        {
            var accountIdClaim = User.FindFirstValue("accountId");
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!Guid.TryParse(accountIdClaim, out Guid accountId) || !Guid.TryParse(userIdClaim, out Guid userId))
                return Unauthorized("Invalid token or no AccountId");

            var userEntity = SyncMapper.ToUserEntity(requestDto.User, userId, accountId);
            var products = SyncMapper.ToProductEntities(requestDto.Products, accountId);
            var clients = SyncMapper.ToClientEntities(requestDto.Clients, accountId);
            var remissions = SyncMapper.ToRemissionEntities(requestDto.Remissions, accountId);

            var result = await _syncUseCase.PushDataAsync(accountId,userEntity, products, clients, remissions);
            if (!result.IsSuccess)
                return BadRequest(result.ErrorMessage);

            var response = new SyncPushResponseDto(
                    result.Value.products,
                    result.Value.clients,
                    result.Value.remissions,
                    DateTime.UtcNow
                );
            return Ok(response);
        }
        //Returns records that are new or have been modified on other devices.
        [HttpGet("pull")]
        public async Task<IActionResult> Pull([FromQuery] DateTime since)
        {
            var accountIdClaim = User.FindFirstValue("accountId");
            var userIdClaim = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (!Guid.TryParse(accountIdClaim, out Guid accountId) || !Guid.TryParse(userIdClaim, out Guid userId))
                return Unauthorized("Invalid token");

            var result = await _syncUseCase.PullDataAsync(userId, accountId, since);
            if (!result.IsSuccess)
                return BadRequest(result.ErrorMessage);

            var (products, clients, remissions) = result.Value;

            var response = new SyncPullResponseDto(
                    SyncMapper.ToProductDtos(products),
                    SyncMapper.ToClientDtos(clients),
                    SyncMapper.ToRemissionDtos(remissions),
                    DateTime.UtcNow
                );
            return Ok(response);
        }

    }
}
