using Microsoft.EntityFrameworkCore;
using transacciones_api.Datos;
using transacciones_api.Entities;
using transacciones_api.Enums;

namespace transacciones_api.Repositories
{
    public class TransaccionRepository: ITransaccionRepository
    {
        private readonly TransaccionesDbContext _context;

        public TransaccionRepository(TransaccionesDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Transaccion>> GetAllAsync()
        {
            return await _context.Transacciones.ToListAsync();
        }

        public async Task<Transaccion?> GetByIdAsync(int id)
        {
            return await _context.Transacciones.FindAsync(id);
        }

        public async Task AddAsync(Transaccion transaccion)
        {
            await _context.Transacciones.AddAsync(transaccion);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Transaccion transaccion)
        {
            _context.Transacciones.Update(transaccion);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Transaccion transaccion)
        {
            _context.Transacciones.Remove(transaccion);
            await _context.SaveChangesAsync();
        }

        public async Task<decimal> GetSaldoAsync()
        {
            decimal ingresos = await _context.Transacciones
                .Where(t => t.Tipo == TipoTransaccion.Ingreso)
                .SumAsync(t => t.Monto);

            decimal gastos = await _context.Transacciones
                .Where(t => t.Tipo == TipoTransaccion.Gasto)
                .SumAsync(t => t.Monto);

            return ingresos - gastos;
        }
    }
}
