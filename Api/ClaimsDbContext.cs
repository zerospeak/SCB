using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;

namespace Api
{
    public class ClaimsDbContext : IdentityDbContext<IdentityUser>
    {
        public ClaimsDbContext(DbContextOptions<ClaimsDbContext> options) : base(options) { }

        public DbSet<Claim> Claims { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Claim>()
                .Property(c => c.PaidAmount)
                .HasPrecision(18, 2);
        }
    }

    public class Claim
    {
        public int Id { get; set; }
        public string ProviderID { get; set; } = string.Empty;
        public string MemberSSN { get; set; } = string.Empty;
        public decimal PaidAmount { get; set; }
        public bool? IsFraud { get; set; }
        public double Risk { get; set; } // For analytics
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }
}
