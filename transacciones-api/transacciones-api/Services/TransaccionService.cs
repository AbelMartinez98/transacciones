using transacciones_api.Entities;
using transacciones_api.Enums;
using transacciones_api.Repositories;

namespace transacciones_api.Services
{
    public class TransaccionService
    {
        private readonly ITransaccionRepository _repository;

        public TransaccionService(ITransaccionRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Transaccion>> GetAllAsync()
        {
            return await _repository.GetAllAsync();
        }

        public async Task<Transaccion?> GetByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task<bool> AddAsync(Transaccion transaccion)
        {
            var saldoActual = await _repository.GetSaldoAsync();

            if (transaccion.Tipo == TipoTransaccion.Gasto && transaccion.Monto > saldoActual)
            {
                return false; // No se puede registrar el gasto si es mayor al saldo
            }

            await _repository.AddAsync(transaccion);
            return true;
        }

        public async Task UpdateAsync(Transaccion transaccion)
        {
            await _repository.UpdateAsync(transaccion);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var transaccion = await _repository.GetByIdAsync(id);
            if (transaccion == null) return false;

            await _repository.DeleteAsync(transaccion);
            return true;
        }
    }
}
