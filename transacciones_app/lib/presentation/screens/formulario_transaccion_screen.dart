import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transacciones_app/core/providers/transacciones_provider.dart';
import 'package:transacciones_app/domain/models/transaccion.dart';

class FormularioTransaccionScreen extends StatelessWidget {
  final Transaccion? transaccion;

  const FormularioTransaccionScreen({super.key, this.transaccion});

  @override
  Widget build(BuildContext context) {
    final transaccionesProvider = Provider.of<TransaccionesProvider>(context, listen: false);

    final TextEditingController montoController = TextEditingController(
      text: transaccion != null ? transaccion!.monto.toString() : '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: transaccion != null ? transaccion!.descripcion : '',
    );

    TipoTransaccion tipoTransaccion = transaccion != null ? transaccion!.tipo : TipoTransaccion.Ingreso;
    CategoriaTransaccion categoriaTransaccion = transaccion != null ? transaccion!.categoria : CategoriaTransaccion.Otros;

    void _guardarTransaccion() {
      if (montoController.text.isEmpty || descripcionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, complete todos los campos'),
        ));
        return;
      }

      final double monto = double.tryParse(montoController.text) ?? 0.0;
      final descripcion = descripcionController.text;

      final newTransaccion = Transaccion(
        id: transaccion?.id, 
        tipo: tipoTransaccion,
        monto: monto,
        fecha: DateTime.now(),
        descripcion: descripcion,
        categoria: categoriaTransaccion,
      );

      // Crear o actualizar transacción
      if (transaccion == null) {
        // Crear nueva transacción
        transaccionesProvider.createTransaccion(newTransaccion).then((_) {
          if (transaccionesProvider.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(transaccionesProvider.errorMessage),
            ));
          } else {
            Navigator.of(context).pop();
          }
        });
      } else {
        // Actualizar transacción
        transaccionesProvider.updateTransaccion(transaccion!.id!, newTransaccion).then((_) {
          if (transaccionesProvider.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(transaccionesProvider.errorMessage),
            ));
          } else {
            Navigator.of(context).pop();
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(transaccion == null ? 'Registrar Transacción' : 'Actualizar Transacción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Tipo de transacción
            DropdownButtonFormField<TipoTransaccion>(
              value: tipoTransaccion,
              decoration: InputDecoration(labelText: 'Tipo de Transacción'),
              items: TipoTransaccion.values.map((tipo) {
                return DropdownMenuItem<TipoTransaccion>(
                  value: tipo,
                  child: Text(tipo == TipoTransaccion.Ingreso ? 'Ingreso' : 'Gasto'),
                );
              }).toList(),
              onChanged: (value) {
                tipoTransaccion = value!;
              },
              validator: (value) => value == null ? 'Selecciona un tipo de transacción' : null,
            ),
            // Monto
            TextFormField(
              controller: montoController,
              decoration: InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa un monto';
                }
                if (double.tryParse(value) == null) {
                  return 'Monto no válido';
                }
                return null;
              },
            ),
            // Descripción
            TextFormField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa una descripción';
                }
                return null;
              },
            ),
            // Categoría
            DropdownButtonFormField<CategoriaTransaccion>(
              value: categoriaTransaccion,
              decoration: InputDecoration(labelText: 'Categoría'),
              items: CategoriaTransaccion.values.map((categoria) {
                return DropdownMenuItem<CategoriaTransaccion>(
                  value: categoria,
                  child: Text(categoria.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                categoriaTransaccion = value!;
              },
              validator: (value) => value == null ? 'Selecciona una categoría' : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _guardarTransaccion,
                child: Text(transaccion == null ? 'Registrar' : 'Actualizar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
