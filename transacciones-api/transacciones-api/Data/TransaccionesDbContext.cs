using Microsoft.EntityFrameworkCore;
using transacciones_api.Entities;

namespace transacciones_api.Datos
{
    public class TransaccionesDbContext: DbContext
    {
        public TransaccionesDbContext(DbContextOptions options): base(options)
        {
        }

        public DbSet<Transaccion> Transacciones { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Transaccion>()
                .Property(t => t.Monto)
                .HasColumnType("decimal(18,2)");

            // Guardo TipoTransaccion como string en la BD
            modelBuilder.Entity<Transaccion>()
                .Property(t => t.Tipo)
                .HasConversion<string>();

            // Guardo CategoriaTransaccion como string en la BD
            modelBuilder.Entity<Transaccion>()
                .Property(t => t.Categoria)
                .HasConversion<string>();
        }

    }
}
