using System.ComponentModel.DataAnnotations;
using transacciones_api.Enums;

namespace transacciones_api.Entities
{
    public class Transaccion
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "El campo {0} es requerido")]
        public required TipoTransaccion Tipo { get; set; }

        [Required(ErrorMessage = "El campo {0} es requerido")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El monto debe ser mayor a 0.")]
        public required decimal Monto { get; set; }

        [Required(ErrorMessage = "El campo {0} es requerido")]
        public required DateTime Fecha { get; set; }

        [StringLength(255)]
        public string? Descripcion { get; set; }

        [Required(ErrorMessage = "El campo {0} es requerido")]
        public required CategoriaTransaccion Categoria { get; set; }
    }
}
