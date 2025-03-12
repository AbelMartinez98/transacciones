enum CategoriaTransaccion { Salario, Alquiler, Alimentacion, Transporte, Entretenimiento, Otros }
enum TipoTransaccion { Ingreso, Gasto }

class Transaccion {
  final int? id;
  final TipoTransaccion tipo;
  final double monto;
  final DateTime fecha;
  final String descripcion;
  final CategoriaTransaccion categoria;

  Transaccion({
    this.id,
    required this.tipo,
    required this.monto,
    required this.fecha,
    required this.descripcion,
    required this.categoria,
  });

  factory Transaccion.fromJson(Map<String, dynamic> json) {
    return Transaccion(
      id: json['id'],
      tipo: TipoTransaccion.values[json['tipo']],
      monto: json['monto'].toDouble(),
      fecha: DateTime.parse(json['fecha']),
      descripcion: json['descripcion'],
      categoria: CategoriaTransaccion.values[json['categoria']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'tipo': tipo.index,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
      'descripcion': descripcion,
      'categoria': categoria.index,
    };
  }
}
