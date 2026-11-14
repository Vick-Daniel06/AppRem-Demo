using AppRem.Domain.Entities.Operational;
using AppRem.Domain.UseCase;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using System.Net.NetworkInformation;
using WebApi.DTOs.WebHook;
using WebApi.Mappers;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [EnableRateLimiting("WebhookPolicy")]
    public class PaymentController : ControllerBase
    {
        private readonly PaymentUseCase _paymentUseCase;
        private readonly IConfiguration _configuration;
        public PaymentController(PaymentUseCase paymentUseCase, IConfiguration configuration)
        {
            _paymentUseCase = paymentUseCase;
            _configuration = configuration;
            
        }
        //Listen for notifications in real time (Webhooks)
        [HttpPost("webhook")]
        [AllowAnonymous]
        public async Task<IActionResult> RevenueCatWebhook([FromBody] RevenueCatWebhookDto request)
        {
            if (request?.Event == null)
                return BadRequest("Invalid webhook payload");

            //Authorization header
            var authHeader = Request.Headers["Authorization"].ToString();
            if (string.IsNullOrWhiteSpace(authHeader))
                return Unauthorized("Missing Authorization Header");

            var expectedSecret = _configuration["RevenueCat:WebhookSecret"];
            if (string.IsNullOrWhiteSpace(expectedSecret))
                return StatusCode(500, "Webhook secret is not configured on the server.");

            var (accountId, store, purchaseToken, productId, status, expiresAt) =
                PaymentMapper.ExtractPaymentData(request);
            if (accountId == Guid.Empty)
                return BadRequest("Invalid AppUserId format");

            var result = await _paymentUseCase.ProcessWebhookAsync(
                    authHeader,
                    expectedSecret,
                    accountId,
                    store,
                    purchaseToken,
                    productId,
                    status,
                    expiresAt
                );
            if (!result.IsSuccess)
            {
                if (result.ErrorMessage!.Contains("unauthorized", StringComparison.OrdinalIgnoreCase) ||
                    result.ErrorMessage.Contains("Invalid", StringComparison.OrdinalIgnoreCase))
                {
                    return Unauthorized(result.ErrorMessage);
                }
                return BadRequest(result.ErrorMessage);
            }
            return Ok(new { received = true});
            
        }
    }
}
