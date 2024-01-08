using Ans3.Models;
using Microsoft.EntityFrameworkCore;
using System.Globalization;

namespace Ans3
{
    public class DBContext : DbContext
    {
        public DBContext(DbContextOptions<DBContext> options) : base(options)
        {
            var originalCulture = CultureInfo.DefaultThreadCurrentCulture;
            var originalUICulture = CultureInfo.DefaultThreadCurrentUICulture;

            CultureInfo.DefaultThreadCurrentCulture = CultureInfo.InvariantCulture;
            CultureInfo.DefaultThreadCurrentUICulture = CultureInfo.InvariantCulture;

            // Perform database operations

            // Revert to original culture
            CultureInfo.DefaultThreadCurrentCulture = originalCulture;
            CultureInfo.DefaultThreadCurrentUICulture = originalUICulture;
        }
        public DbSet<PayloadDataModel> PayloadDataModels { get; set; }

        public DbSet<DataModel> DataModels { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // ...
            var cascadeFKs = modelBuilder.Model.GetEntityTypes()
                .SelectMany(t => t.GetForeignKeys())
                .Where(fk => !fk.IsOwnership && fk.DeleteBehavior == DeleteBehavior.Cascade);

            foreach (var fk in cascadeFKs)
                fk.DeleteBehavior = DeleteBehavior.Restrict;

            base.OnModelCreating(modelBuilder);
        }
    }
}

//dotnet tool install --global dotnet-ef
//dotnet ef migrations add InitialCreate
//dotnet ef database update
