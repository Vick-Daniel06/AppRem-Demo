

using AppRem.Domain.Entities.Operational;
using AppRem.Domain.Entities.Security;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics.Metrics;

namespace AppRem.Data.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        //Security Tables
        public DbSet<Account> Accounts { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<Identity>Identities { get; set; }
        public DbSet<PurchasesLog> PurchasesLogs { get; set; }
        public DbSet<RefreshToken> RefreshTokens { get; set; }

        //Operational Tables
        public DbSet<Client> Clients { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Remission> Remissions { get; set; }
        public DbSet<DetailLine> DetailLines { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            //UNIQUE(provider, providerUid) constraint that prevents duplicate cloud credentials.
            modelBuilder.Entity<Identity>()
                .HasIndex(i => new { i.Provider, i.ProviderUid })
                .IsUnique();
            //UNIQUE(purchaseToken) constraint acting as an anti-replay and anti-fraud safeguard
            modelBuilder.Entity<PurchasesLog>()
                .HasKey(p => p.PurchaseLogId);
            modelBuilder.Entity<PurchasesLog>()
                .HasIndex(p=> p.PurchaseToken)
                .IsUnique();
            //Convert the Enum string ('Unidad, Pesos, Metro') so that it is saved as text.
            modelBuilder.Entity<Product>()
                .Property(p => p.SaleMethod)
                .HasConversion<string>()
                .HasMaxLength(20);
            //DECIMAL PRECISION (Money and Amounts)
            //(18 digits, 4 decimal places for grams / meters)
            modelBuilder.Entity<DetailLine>().Property(d => d.Amount).HasColumnType("decimal(18,4)");
            modelBuilder.Entity<DetailLine>().Property(d => d.OriginalSuggestedPrice).HasColumnType("decimal(18,2)");
            modelBuilder.Entity<DetailLine>().Property(d => d.UnitPriceAtThatTime).HasColumnType("decimal(18,2)");
            modelBuilder.Entity<DetailLine>().Property(d => d.SubTotal).HasColumnType("decimal(18,2)");

            modelBuilder.Entity<Remission>().Property(r => r.TotalAmount).HasColumnType("decimal(18,2)");
            modelBuilder.Entity<Product>().Property(p => p.SuggestedPrice).HasColumnType("decimal(18,2)");

            //RELATIONSHIPS (Foreign Keys and Cascade Delete)
            modelBuilder.Entity<Remission>()
                .HasMany(r => r.Details)
                .WithOne()
                .HasForeignKey(d => d.RemissionId)
                .OnDelete(DeleteBehavior.Cascade); //Cascade delete: When a remission is deleted, its details are also deleted.

            //Operational entities are linked to AccountId to ensure data isolation.
            modelBuilder.Entity<Product>()
                .HasOne<Account>()
                .WithMany()
                .HasForeignKey(p => p.AccountId)
                .OnDelete(DeleteBehavior.NoAction);
            modelBuilder.Entity<Client>()
                .HasOne<Account>()
                .WithMany()
                .HasForeignKey(c => c.AccountId)
                .OnDelete(DeleteBehavior.NoAction);
            modelBuilder.Entity<Remission>()
                .HasOne<Account>()
                .WithMany()
                .HasForeignKey(r => r.AccountId)
                .OnDelete(DeleteBehavior.NoAction);

        }
    }
}
