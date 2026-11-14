using AppRem.Data.Data;
using AppRem.Domain.Core;
using AppRem.Domain.Entities.Operational;
using AppRem.Domain.Entities.Security;
using AppRem.Domain.Interface;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppRem.Data.Repositories
{
    public class SyncRepository: ISyncRepository
    {
        private readonly AppDbContext _context;
        public SyncRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Result<List<Guid>>> UpsertProductsAsync(IEnumerable<Product> products, Guid accountId)
        {
            var processedIds = new List<Guid>();

            try
            {
                foreach (var incomingProduct in products)
                {
                    // Total isolation. We only look for the product if it belongs to the token's AccountId.
                    var existingProduct = await _context.Products
                        .FirstOrDefaultAsync(p => p.ProductId == incomingProduct.ProductId && p.AccountId == accountId);

                    if (existingProduct == null)
                    {
                        // if the product does not exist, we add it to the database
                        await _context.Products.AddAsync(incomingProduct);
                        processedIds.Add(incomingProduct.ProductId);
                    }
                    else
                    {
                       
                        // We only update if the Flutter version is newer.
                        if (incomingProduct.UpdatedAt > existingProduct.UpdatedAt)
                        {

                            //We update the properties while respecting the entity's encapsulation.
                            var updateResult = existingProduct.UpdateDetails(
                                incomingProduct.Name,
                                incomingProduct.SuggestedPrice,
                                incomingProduct.SaleMethod,
                                incomingProduct.WeightKg,
                                incomingProduct.Description,
                                incomingProduct.UpdatedAt
                            );
                            if (incomingProduct.DeletedAt.HasValue && !existingProduct.DeletedAt.HasValue)
                        {
                            existingProduct.MarkAsDeleted(incomingProduct.DeletedAt.Value);
                        }
                            if (updateResult.IsSuccess)
                            {
                                _context.Products.Update(existingProduct);
                                processedIds.Add(existingProduct.ProductId);
                            }
                        }
                        else
                        {
                            // Si el de Flutter es más viejo, lo ignoramos, pero lo marcamos como "procesado" 
                            // para que la app móvil deje de intentar enviarlo.
                            processedIds.Add(incomingProduct.ProductId);
                        }
                    }
                }

                await _context.SaveChangesAsync();

                return Result<List<Guid>>.Success(processedIds);
            }
            catch (Exception ex)
            {
                
                return Result<List<Guid>>.Failure($"Database error while processing products: {ex.Message}");
            }
        }

        public async Task<Result<List<Guid>>> UpsertClientAsync(IEnumerable<Client> clients, Guid accountId)
        {
            var processedIds = new List<Guid>();
            try
            {
                foreach (var incoming in clients)
                {
                    var existing = await _context.Clients
                        .FirstOrDefaultAsync(c => c.ClientId == incoming.ClientId && c.AccountId == accountId);

                    if (existing == null)
                    {
                        await _context.Clients.AddAsync(incoming);
                        processedIds.Add(incoming.ClientId);
                    }
                    else if (incoming.UpdatedAt > existing.UpdatedAt)
                    {
                        var updateResult = existing.UpdateInfo(incoming.ClientName, incoming.LocationClient, incoming.UpdatedAt);
                        if (incoming.DeletedAt.HasValue && !existing.DeletedAt.HasValue)
                        {
                            existing.MarkAsDeleted(incoming.DeletedAt.Value);
                        }
                        if (updateResult.IsSuccess)
                        {
                            _context.Clients.Update(existing);
                            processedIds.Add(existing.ClientId);
                        }
                    }
                    else
                    {
                        processedIds.Add(incoming.ClientId);
                    }
                }
                await _context.SaveChangesAsync();
                return Result<List<Guid>>.Success(processedIds);
            }
            catch (Exception ex)
            {
                return Result<List<Guid>>.Failure($"Data Base Error: {ex.Message}");
            }
        }
        public async Task<Result<List<Guid>>> UpsertRemissionAsync(IEnumerable<Remission> remissions, Guid accountId)
        {
            var processedIds = new List<Guid>();
            //To prevent a detail line from failing to save.
            using var transactioin = await _context.Database.BeginTransactionAsync();

            try
            {
                foreach (var incoming in remissions)
                {
                    var existing = await _context.Remissions
                        .Include(r => r.Details)
                        .FirstOrDefaultAsync(r => r.RemissionId == incoming.RemissionId && r.AccountId == accountId);
                    if (existing == null)
                    {
                        incoming.RecalculateTotal();
                        await _context.Remissions.AddAsync(incoming);
                        processedIds.Add(incoming.RemissionId);
                    }
                    else
                    {
                        //Update only if the incoming remission is newer.
                        if (incoming.UpdatedAt > existing.UpdatedAt)
                        {
                            existing.UpdateEvidenceAndSignatures(
                                    incoming.ClientSignaturePath,
                                    incoming.UserSignaturePath,
                                    incoming.CompanyPhotoPath,
                                    incoming.FotoEvidenciaPath,
                                    incoming.UpdatedAt
                                );
                            // Handle the details
                            // Remove details that are not in the incoming list
                            var incomingDetailIds = incoming.Details.Select(d => d.DetailLineId).ToList();
                            var detailsToRemove = existing.Details.Where(d => !incomingDetailIds.Contains(d.DetailLineId)).ToList();
                            foreach (var detail in detailsToRemove)
                            {
                                existing.RemoveDetail(detail);
                                _context.DetailLines.Remove(detail);
                            }
                            // Add or update incoming details
                            foreach (var incomingDetail in incoming.Details)
                            {
                                var existingDetail = existing.Details.FirstOrDefault(d => d.DetailLineId == incomingDetail.DetailLineId);
                                if (existingDetail == null)
                                {
                                    //new line to a existing remission
                                    existing.AddDetailLine(incomingDetail);
                                    _context.DetailLines.Add(incomingDetail);
                                }
                                else
                                {
                                    // Update existing detail
                                    existingDetail.UpdateLine(
                                            incomingDetail.Amount,
                                            incomingDetail.OriginalSuggestedPrice,
                                            incomingDetail.UnitPriceAtThatTime,
                                            incomingDetail.Description
                                        );
                                }
                            }
                            existing.RecalculateTotal();
                            _context.Remissions.Update(existing);
                            processedIds.Add(existing.RemissionId);

                        }
                        else
                        {
                            processedIds.Add(incoming.RemissionId);
                        }
                    }
                }
                await _context.SaveChangesAsync();
                await transactioin.CommitAsync();
                return Result<List<Guid>>.Success(processedIds);
            }
            catch(Exception ex) { 
                await transactioin.RollbackAsync();
                return Result<List<Guid>>.Failure($"Error while synchronizing delivery notes: {ex.Message}");
            }
        }
        public async Task<Result<bool>> UpsertUserAsync(User user, Guid accountId)
        {
            try
            {
                // Filtro de ownership asegurando que el UserId pertenezca al AccountId del token
                var existingUser = await _context.Users
                    .FirstOrDefaultAsync(u => u.UserId == user.UserId && u.AccountId == accountId);

                if (existingUser == null)
                    return Result<bool>.Failure("User not found or does not belong to the authenticated account.");

                // Solo actualizamos si la estampa de tiempo de Flutter es más reciente (Idempotencia)
                if (user.UpdatedAt > existingUser.UpdatedAt)
                {
                    var updateResult = existingUser.UpdateProfile(
                        user.UserName,
                        existingUser.Email, // Conservamos intacto el email verificado de Google/Apple
                        user.UserSignatureUrl,
                        user.UpdatedAt
                    );

                    if (!updateResult.IsSuccess)
                        return Result<bool>.Failure(updateResult.ErrorMessage!);

                    _context.Users.Update(existingUser);
                    await _context.SaveChangesAsync();
                }

                return Result<bool>.Success(true);
            }
            catch (Exception ex)
            {
                return Result<bool>.Failure($"Error syncing user data: {ex.Message}");
            }
        }

        public async Task<Result<IEnumerable<Product>>> GetProductsSinceAsync(Guid accountId, DateTime since)
        {
            var data = await _context.Products.Where(p => p.AccountId == accountId && p.ServerUpdateAt > since).ToListAsync();
            return Result<IEnumerable<Product>>.Success(data);
        }

        public async Task<Result<IEnumerable<Client>>> GetClientsSinceAsync(Guid accountId, DateTime since)
        {
            var data = await _context.Clients.Where(c => c.AccountId == accountId && c.ServerUpdateAt > since).ToListAsync();
            return Result<IEnumerable<Client>>.Success(data);
        }

        public async Task<Result<IEnumerable<Remission>>> GetRemissionsSinceAsync(Guid accountId, DateTime since)
        {
            var data = await _context.Remissions.Include(r => r.Details)
                .Where(r => r.AccountId == accountId && r.ServerUpdateAt > since).ToListAsync();
            return Result<IEnumerable<Remission>>.Success(data);
        }
    }
}

