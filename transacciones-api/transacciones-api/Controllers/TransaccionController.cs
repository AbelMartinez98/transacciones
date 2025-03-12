using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using transacciones_api.DTOs;
using transacciones_api.Entities;
using transacciones_api.Services;

namespace transacciones_api.Controllers
{
    [ApiController]
    [Route("api/transaccion")]
    public class TransaccionController : ControllerBase
    {
        private readonly TransaccionService _service;

        public TransaccionController(TransaccionService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var transacciones = await _service.GetAllAsync();
            return Ok(transacciones);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] TransaccionDTO dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var transaccion = new Transaccion
            {
                Tipo = dto.Tipo,
                Monto = dto.Monto,
                Fecha = dto.Fecha,
                Descripcion = dto.Descripcion,
                Categoria = dto.Categoria
            };

            bool creado = await _service.AddAsync(transaccion);
            if (!creado)
            {
                var problemDetails = new ProblemDetails
                {
                    Status = 400,
                    Title = "Saldo Insuficiente",
                    Detail = "No se puede realizar el gasto debido a saldo insuficiente.",
                    Instance = HttpContext.Request.Path
                };

                return BadRequest(problemDetails);
            }
            //if (!creado) BaRequest("No se puede realizar el gasto debido a saldo insuficiente.");

            return CreatedAtAction(nameof(GetAll), new { id = transaccion.Id }, transaccion);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] TransaccionDTO dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var transaccion = await _service.GetByIdAsync(id);
            if (transaccion == null) return NotFound();

            transaccion.Tipo = dto.Tipo;
            transaccion.Monto = dto.Monto;
            transaccion.Fecha = dto.Fecha;
            transaccion.Descripcion = dto.Descripcion;
            transaccion.Categoria = dto.Categoria;

            await _service.UpdateAsync(transaccion);
            return Ok();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            bool eliminado = await _service.DeleteAsync(id);
            if (!eliminado) return NotFound();

            return NoContent();
        }
    }
}
