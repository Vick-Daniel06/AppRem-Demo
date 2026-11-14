using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Interface
{
    //Azure Blob Storage Service
    public interface IBlobStorageService
    {
        //Receives a file in memory and returns the signed remote URL.
        Task<Result<string>> UploadFileAsync(Stream fileStream,Guid accountId, string fileName, string contentType);
        Task<Result<bool>> DeleteFileAsync(string fileUrl);
    }
}
