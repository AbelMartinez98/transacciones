using transacciones_api.Entities;

namespace transacciones_api.Repositories
{
    public interface ITransaccionRepository
    {
        Task<IEnumerable<Transaccion>> GetAllAsync();
        Task<Transaccion?> GetByIdAsync(int id);
        Task AddAsync(Transaccion transaccion);
        Task UpdateAsync(Transaccion transaccion);
        Task DeleteAsync(Transaccion transaccion);
        Task<decimal> GetSaldoAsync();
    }
}
