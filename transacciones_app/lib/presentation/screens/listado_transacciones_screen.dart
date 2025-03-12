import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:transacciones_app/domain/models/transaccion.dart';
import 'package:transacciones_app/core/providers/transacciones_provider.dart';
import 'package:transacciones_app/presentation/screens/formulario_transaccion_screen.dart';

// Widget para mostrar el saldo total
class SaldoTotalWidget extends StatelessWidget {
  final double saldoTotal;

  const SaldoTotalWidget({super.key, required this.saldoTotal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Saldo Total: ${saldoTotal.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Widget para mostrar la información de cada transacción
class TransaccionTile extends StatelessWidget {
  final Transaccion transaccion;

  const TransaccionTile({super.key, required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final tipoColor =
        transaccion.tipo == TipoTransaccion.Ingreso ? Colors.green : Colors.red;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: ListTile(
        title: Text(
          transaccion.descripcion,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(transaccion.fecha),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              'Categoría: ${transaccion.categoria.toString().split('.').last}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Text(
          '\$${transaccion.monto.toStringAsFixed(2)}',
          style: TextStyle(
            color: tipoColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      FormularioTransaccionScreen(transaccion: transaccion),
            ),
          );
        },
      ),
    );
  }
}

// Widget para listar las transacciones
class ListarTransacciones extends StatelessWidget {
  const ListarTransacciones({super.key});

  @override
  Widget build(BuildContext context) {
    final transaccionesProvider = Provider.of<TransaccionesProvider>(context);

    if (transaccionesProvider.transacciones.isEmpty &&
        !transaccionesProvider.isLoading &&
        transaccionesProvider.errorMessage.isNotEmpty) {
      transaccionesProvider.loadTransacciones();
    }

    return Expanded(
      child:
          transaccionesProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : transaccionesProvider.transacciones.isEmpty
              ? Center(child: Text('No hay transacciones disponibles'))
              : ListView.builder(
                itemCount: transaccionesProvider.transacciones.length,
                itemBuilder: (context, index) {
                  final transaccion =
                      transaccionesProvider.transacciones[index];
                  return TransaccionTile(transaccion: transaccion);
                },
              ),
    );
  }
}

// Pantalla principal de Listado de Transacciones
class ListadoTransaccionesScreen extends StatelessWidget {
  const ListadoTransaccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transaccionesProvider = Provider.of<TransaccionesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Transacciones')),
      body: Column(
        children: [
          SaldoTotalWidget(saldoTotal: transaccionesProvider.saldoTotal),
          ListarTransacciones(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormularioTransaccionScreen(),
            ),
          );
        },
        tooltip: 'Agregar Nueva Transacción',
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
