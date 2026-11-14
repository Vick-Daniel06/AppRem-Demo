using AppRem.Data.Data;
using AppRem.Data.Repositories;
using AppRem.Data.Services;
using AppRem.Domain.Interface;
using AppRem.Domain.UseCase;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Text;
using System.Threading.RateLimiting;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});

builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        // Add a converter to serialize enums as strings in JSON
        options.JsonSerializerOptions.Converters.Add(new System.Text.Json.Serialization.JsonStringEnumConverter());
    });
//Dependency Injection

builder.Services.AddScoped<ISyncRepository, SyncRepository>();
builder.Services.AddScoped<IAuthRepository, AuthRepository>();
builder.Services.AddScoped<ISyncUseCase, SyncUseCase>();
builder.Services.AddScoped<IPaymentRepository, PaymentRepository>();
//External services
builder.Services.AddScoped<IJwtTokenGenerator, JwtGenerator>();
//Storage local
builder.Services.AddScoped<IBlobStorageService, LocalStorageService>();

//UseCase
builder.Services.AddScoped<SyncUseCase>();
builder.Services.AddScoped<AuthUseCase>();
builder.Services.AddScoped<PaymentUseCase>();

//Jwt configuration
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var secretKey = jwtSettings["SecretKey"];
if (string.IsNullOrWhiteSpace(secretKey) || Encoding.UTF8.GetBytes(secretKey).Length < 64)
{
    throw new InvalidOperationException("The JWT secret key must be at least 64 bytes long.");
}
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;//Solo para desarrollo local, en producción debe ser true
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey)),
      
        ClockSkew = TimeSpan.Zero
    };
});
//Authorization global
builder.Services.AddAuthorization();

//RATE LIMITING
builder.Services.AddRateLimiter(
    options => {
        //Policy for Auth
        //Maximum of 10 attempts per minute per IP to mitigate brute-force attacks
        options.AddPolicy("AuthPolicy", httpContext =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey: httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown_ip",
            factory: _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 10,
                Window = TimeSpan.FromMinutes(1),
                QueueLimit = 0
            }
            ));
        //Policy for Webhook
        // Allows legitimate bursts from the payment server
        options.AddPolicy("WebhookPolicy", htttContext =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey: htttContext.Connection.RemoteIpAddress?.ToString() ?? "revenuecat_ip",
            factory: _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 60,
                Window = TimeSpan.FromMinutes(1),
                QueueLimit = 2
            }));
        //Policy Sync(/push, /pull, /upload)
        //If an account abuses synchronization, only that account is throttled—not other users on the same WiFi network.
        options.AddPolicy("SyncPolicy", httpContext =>
        {
            var accountId = httpContext.User.FindFirstValue("accountId")
                            ?? httpContext.Connection.RemoteIpAddress?.ToString()
                            ?? "anonymous";
            return RateLimitPartition.GetFixedWindowLimiter(
                partitionKey: accountId,
                factory: _ => new FixedWindowRateLimiterOptions
                {
                    PermitLimit = 30,
                    Window = TimeSpan.FromMinutes(1),
                    QueueLimit = 0
                });

        });
    }
    );

var app = builder.Build();


app.UseHttpsRedirection(); //HTTPS


app.UseAuthentication();
app.UseAuthorization();

//to open locals URL with authentication
app.UseStaticFiles( new StaticFileOptions
{
    //Only files in the "evidences" folder are protected
    OnPrepareResponse = ctx =>
    {
        if (ctx.Context.Request.Path.StartsWithSegments("/evidences"))
        {
            //if the token is not valid, return 401 Unauthorized and block access to the file
            if (!ctx.Context.User.Identity?.IsAuthenticated ?? true)
            {
                ctx.Context.Response.StatusCode = 401;
                ctx.Context.Response.ContentLength = 0;
                ctx.Context.Response.Body = Stream.Null;
            }
        }
    }
});

//Policy Rate Limiting
app.UseRateLimiter();

app.MapControllers();
app.Run();


