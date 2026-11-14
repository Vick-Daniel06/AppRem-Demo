using AppRem.Domain.Core;
using AppRem.Domain.Entities.Operational;
using AppRem.Domain.Entities.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Interface
{
    public interface ISyncUseCase
    {
        Task<Result<string>> UploadFileAsync(Guid accountId, Stream fileStream, string contentType);
        //Orchestrates the upload (push) of a complete batch.
        Task<Result<(List<Guid> products, List<Guid> clients, List<Guid> remissions)>> PushDataAsync(
            Guid accountId,
            User? user,
            IEnumerable<Product> products,
            IEnumerable<Client> clients,
            IEnumerable<Remission> remissions);

        Task<Result<(IEnumerable<Product>, IEnumerable<Client>, IEnumerable<Remission>)>> PullDataAsync(Guid userId, Guid accountId, DateTime since);
    }
}
