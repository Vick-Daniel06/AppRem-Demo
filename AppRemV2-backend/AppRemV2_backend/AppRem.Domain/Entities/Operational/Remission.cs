using AppRem.Domain.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Domain.Entities.Operational
{
    public class Remission
    {
        public Guid RemissionId { get; private set; }
        public Guid ClientId { get; private set; }
        public Guid AccountId { get; private set; }
        public string Folio { get; private set; } = string.Empty;
        public DateTime CreationDate { get; private set; }
        public string CompanyNameSnapshot { get; private set; } = string.Empty;
        public string ClientNameSnapshot { get; private set; } = string.Empty;
        public decimal TotalAmount { get; private set; }
        public string ClientSignaturePath { get; private set; } = string.Empty;
        public string? UserSignaturePath { get; private set; }
        public string? CompanyPhotoPath { get; private set; }
        public string? FotoEvidenciaPath { get; private set; }
        public DateTime UpdatedAt { get; private set; }
        public DateTime ServerUpdateAt { get; private set; }

        // Propiedad de navegación encapsulada (Solo la clase puede modificar la lista directamente)
        private readonly List<DetailLine> _details = new();
        public IReadOnlyCollection<DetailLine> Details => _details.AsReadOnly();

        private Remission() { }

        private Remission(Guid remissionId, Guid clientId, Guid accountId, string folio,
                          DateTime creationDate, string companyNameSnapshot, string clientNameSnapshot,
                          string clientSignaturePath, string? userSignaturePath, string? companyPhotoPath,
                          string? fotoEvidenciaPath, DateTime updatedAt)
        {
            RemissionId = remissionId;
            ClientId = clientId;
            AccountId = accountId;
            Folio = folio;
            CreationDate = creationDate;
            CompanyNameSnapshot = companyNameSnapshot;
            ClientNameSnapshot = clientNameSnapshot;
            ClientSignaturePath = clientSignaturePath;
            UserSignaturePath = userSignaturePath;
            CompanyPhotoPath = companyPhotoPath;
            FotoEvidenciaPath = fotoEvidenciaPath;
            UpdatedAt = updatedAt;
            ServerUpdateAt = DateTime.UtcNow;
            TotalAmount = 0; // Inicia en 0 hasta que se agreguen las líneas
        }

        public static Result<Remission> Create(Guid remissionId, Guid clientId, Guid accountId, string folio,
                                               DateTime creationDate, string companyNameSnapshot,
                                               string clientNameSnapshot, string clientSignaturePath,
                                               string? userSignaturePath, string? companyPhotoPath,
                                               string? fotoEvidenciaPath, DateTime updatedAt)
        {
            var remission = new Remission(remissionId, clientId, accountId, folio, creationDate,
                                          companyNameSnapshot, clientNameSnapshot, clientSignaturePath,
                                          userSignaturePath, companyPhotoPath, fotoEvidenciaPath, updatedAt);

            return Result<Remission>.Success(remission);
        }

        public void RemoveDetail(DetailLine detail)
        {
            var itemToRomove = _details.FirstOrDefault(d => d.DetailLineId == detail.DetailLineId);
            if (itemToRomove != null)
            {
                _details.Remove(itemToRomove);
                ServerUpdateAt = DateTime.UtcNow;
            }
        }
   
        public void AddDetailLine(DetailLine line)
        {
            _details.Add(line);
            RecalculateTotal();
        }

        public void UpdateEvidenceAndSignatures(
        string? clientSignaturePath,
        string? userSignaturePath,
        string? companyPhotoPath,
        string? fotoEvidenciaPath,
        DateTime updatedAt)
        {
            if (!string.IsNullOrWhiteSpace(clientSignaturePath))
                ClientSignaturePath = clientSignaturePath;

            UserSignaturePath = userSignaturePath;
            CompanyPhotoPath = companyPhotoPath;
            FotoEvidenciaPath = fotoEvidenciaPath;

            UpdatedAt = updatedAt;
            ServerUpdateAt = DateTime.UtcNow;
        }

        public void RecalculateTotal()
        {
            TotalAmount = _details != null ? _details.Sum(d => d.SubTotal) : 0;
            ServerUpdateAt = DateTime.UtcNow;
        }
    }
}
