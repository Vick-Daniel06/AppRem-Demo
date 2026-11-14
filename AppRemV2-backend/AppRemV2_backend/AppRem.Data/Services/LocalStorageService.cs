using AppRem.Domain.Core;
using AppRem.Domain.Interface;
using Microsoft.Extensions.Configuration;



namespace AppRem.Data.Services
{
    public class LocalStorageService : IBlobStorageService
    {
        private readonly IConfiguration _configuration;
        private readonly string _uploadFolder = "evidences";

        private readonly Dictionary<string, byte[]> _allowedMagicBytes = new()
        {
            { ".jpg", new byte[] { 0xFF, 0xD8, 0xFF } },
            { ".jpeg", new byte[] { 0xFF, 0xD8, 0xFF } },
            { ".png", new byte[] { 0x89, 0x50, 0x4E, 0x47 } }
        };

        public LocalStorageService(IConfiguration configuration) {
            _configuration = configuration;
        }

        public async Task<Result<string>> UploadFileAsync(Stream fileStrem, Guid accountId, string filename, string contentType)
        {
            try {
                filename = filename.ToLowerInvariant();

                if (!contentType.StartsWith("image/"))
                    return Result<string>.Failure("Format not allowed. Only images are accepted.");
                var extension = Path.GetExtension(filename);
                if(string.IsNullOrEmpty(extension) || !_allowedMagicBytes.ContainsKey(extension))
                     return Result<string>.Failure("Extension not allowed.");

                //Validation of the magic bytes
                using var memooryStream = new MemoryStream();
                await fileStrem.CopyToAsync(memooryStream);
                var fileBytes = memooryStream.ToArray();

                var magicBytes = _allowedMagicBytes[extension];
                if (fileBytes.Length < magicBytes.Length || !fileBytes.Take(magicBytes.Length).SequenceEqual(magicBytes))
                    return Result<string>.Failure("File content does not match the expected format.");

                //points to the API root
                //Create the folder whit his accountId
                var folderPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", _uploadFolder, accountId.ToString());
                if (!Directory.Exists(folderPath))
                    Directory.CreateDirectory(folderPath);

                //Generate a secure file name
                var secureFileName = $"{Guid.NewGuid()}{extension}";
                var filePath = Path.Combine(folderPath, secureFileName);

                //Save the file
                await File.WriteAllBytesAsync(filePath, fileBytes);
                //Get the URL and retorn it
                var baseUrl = _configuration["LocalStorage:BaseUrl"];
                var fileUrl = $"{baseUrl}/{_uploadFolder}/{accountId}/{secureFileName}";

                return Result<string>.Success(fileUrl);
            }
            catch (Exception e)
            {
                return Result<string>.Failure($"Error saving local file: {e.Message}");
            }
        }
        public async Task<Result<bool>> DeleteFileAsync(string fileUrl)
        {
            try {
                if (string.IsNullOrWhiteSpace(fileUrl)) return Result<bool>.Success(true);

                string fileName;
                if (Uri.TryCreate(fileUrl, UriKind.Absolute, out var uri))
                {
                    fileName = Path.GetFileName(uri.LocalPath);
                }
                else
                {
                    fileName = Path.GetFileName(fileUrl);
                }

                var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", _uploadFolder, fileName);

                if (File.Exists(filePath))
                    File.Delete(filePath);

                return Result<bool>.Success(true);
            }
            catch (Exception ex)
            {
                return Result<bool>.Failure($"Error to delete the local file: {ex.Message}");

            }
        }
    }
}
