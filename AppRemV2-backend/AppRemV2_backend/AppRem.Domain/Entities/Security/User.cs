using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Security
{
    public class User
    {
        public Guid UserId { get; private set; }
        public Guid AccountId { get; private set; }
        public string? UserName { get; private set; }
        public string? Email { get; private set; }
        public string? UserSignatureUrl { get; private set; }
        public DateTime CreatedAt { get; private set; }
        public DateTime UpdatedAt { get; private set; }
        public DateTime ServerUpdateAt { get; private set; }

        private User() { }

        private User(Guid userId, Guid accountId, string? userName, string? email,
                     string? userSignatureUrl, DateTime createdAt, DateTime updatedAt)
        {
            UserId = userId;
            AccountId = accountId;
            UserName = userName;
            Email = email;
            UserSignatureUrl = userSignatureUrl;
            CreatedAt = createdAt;
            UpdatedAt = updatedAt;
            ServerUpdateAt = DateTime.UtcNow; 
        }

        public static Result<User> Create(Guid userId, Guid accountId, string? userName,
                                          string? email, string? userSignatureUrl,
                                          DateTime createdAt, DateTime updatedAt)
        {
            var user = new User(userId, accountId, userName, email, userSignatureUrl, createdAt, updatedAt);
            return Result<User>.Success(user);
        }

        public Result<bool> UpdateProfile(string? userName, string? email, string? userSignatureUrl, DateTime updatedAt)
        {
            UserName = userName;
            Email = email;
            UserSignatureUrl = userSignatureUrl;
            UpdatedAt = updatedAt;
            ServerUpdateAt = DateTime.UtcNow;

            return Result<bool>.Success(true);
        }
    }
}
