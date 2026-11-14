using AppRem.Domain.Core;
using AppRem.Domain.Interface;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Sas;
using Microsoft.Extensions.Configuration;

namespace AppRem.Data.Services
{
    public class BlobStorageService : IBlobStorageService
    {
        private readonly BlobContainerClient _containerClient;

        public BlobStorageService(IConfiguration configuration)
        {
            var connectionString = configuration["AzureStorage:ConnectionString"];
            var containerName = configuration["AzureStorage:ContainerName"] ?? "evidencias";

            _containerClient = new BlobContainerClient(connectionString, containerName);
        }
        public async Task<Result<string>> UploadFileAsync(Stream fileStream,Guid accountId, string fileName, string contentType)
        {
            try
            {
                // Garantiza que el contenedor exista y sea estrictamente PRIVADO (PublicAccessType.None)
                await _containerClient.CreateIfNotExistsAsync(PublicAccessType.None);

                var blobClient = _containerClient.GetBlobClient(fileName);

                var uploadOptions = new BlobUploadOptions
                {
                    HttpHeaders = new BlobHttpHeaders { ContentType = contentType }
                };

                await blobClient.UploadAsync(fileStream, uploadOptions);

                // Generamos una URL firmada (SAS) con expiración corta (ej. 60 minutos)
                if (blobClient.CanGenerateSasUri)
                {
                    var sasBuilder = new BlobSasBuilder
                    {
                        BlobContainerName = _containerClient.Name,
                        BlobName = blobClient.Name,
                        Resource = "b", // "b" indica que el permiso es solo sobre este Blob específico
                        StartsOn = DateTimeOffset.UtcNow.AddMinutes(-5),
                        ExpiresOn = DateTimeOffset.UtcNow.AddMinutes(60)
                    };

                    // Solo damos permiso de lectura (Read)
                    sasBuilder.SetPermissions(BlobSasPermissions.Read);

                    var sasUri = blobClient.GenerateSasUri(sasBuilder);
                    return Result<string>.Success(sasUri.ToString());
                }

                return Result<string>.Success(blobClient.Uri.ToString());
            }
            catch (Exception ex)
            {
                return Result<string>.Failure($"Error uploading file to Azure Blob Storage: {ex.Message}");
            }
        }
        public async Task<Result<bool>> DeleteFileAsync(string fileUrl)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(fileUrl))
                    return Result<bool>.Failure("The file URL cannot be empty.");

                string blobName;

                // Si recibe una URL completa de Azure (con o sin parámetros SAS), extrae solo el nombre interno del Blob
                if (Uri.TryCreate(fileUrl, UriKind.Absolute, out var uri))
                {
                    var blobUriBuilder = new BlobUriBuilder(uri);
                    blobName = blobUriBuilder.BlobName;
                }
                else
                {
                    // Si recibe la ruta relativa directamente (ej. "{accountId}/{guid}.png")
                    blobName = fileUrl;
                }

                if (string.IsNullOrWhiteSpace(blobName))
                    return Result<bool>.Failure("\r\nThe blob name could not be identified from the URL.");

                var blobClient = _containerClient.GetBlobClient(blobName);

                // DeleteIfExistsAsync evita errores si el archivo ya fue borrado previamente (Idempotencia)
                var response = await blobClient.DeleteIfExistsAsync(DeleteSnapshotsOption.IncludeSnapshots);

                return Result<bool>.Success(response.Value);
            }
            catch (Exception ex)
            {
                return Result<bool>.Failure($"Error deleting the file from Azure Blob Storage: {ex.Message}");
            }
        }
    }
}
