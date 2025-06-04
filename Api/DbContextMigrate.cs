using Microsoft.EntityFrameworkCore;

namespace Api
{
    public static class DbContextMigrate
    {
        public static void EnsureMigration(WebApplication app)
        {
            using var scope = app.Services.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<ClaimsDbContext>();
            db.Database.Migrate();
        }
    }
}
