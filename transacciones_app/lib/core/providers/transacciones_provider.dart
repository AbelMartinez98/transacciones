import 'package:flutter/material.dart';
import 'package:transacciones_app/domain/models/transaccion.dart';
import '../../data/services/api_service.dart';

class TransaccionesProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Transaccion> _transacciones = [];
  double _saldoTotal = 0.0;
  bool _isLoading = false;
  String _errorMessage = '';

  List<Transaccion> get transacciones => _transacciones;
  double get saldoTotal => _saldoTotal;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Método para cargar las transacciones desde la API
  Future<void> loadTransacciones() async {
    if (_transacciones.isNotEmpty) return;

    _isLoading = true;
    _errorMessage = '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      _transacciones = await _apiService.fetchTransacciones();
      _saldoTotal = _transacciones.fold(0.0, (sum, transaccion) {
        return transaccion.tipo == TipoTransaccion.Ingreso
            ? sum + transaccion.monto
            : sum - transaccion.monto;
      });
    } catch (e) {
      _errorMessage = 'Error al cargar las transacciones: $e';
    } finally {
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Método para crear una nueva transacción
  Future<void> createTransaccion(Transaccion transaccion) async {
    _errorMessage = '';
    try {
      final newTransaccion = await _apiService.createTransaccion(transaccion);
      _transacciones.add(newTransaccion);
      _saldoTotal +=
          (newTransaccion.tipo == TipoTransaccion.Ingreso)
              ? newTransaccion.monto
              : -newTransaccion.monto;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Método para actualizar una transacción existente
  Future<void> updateTransaccion(int id, Transaccion transaccion) async {
    _errorMessage = '';
    try {
      if (transaccion.id == null) {
        throw Exception('No se puede actualizar una transacción sin un id');
      }

      await _apiService.updateTransaccion(id, transaccion);
      int index = _transacciones.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transacciones[index] = transaccion;
        _saldoTotal = _transacciones.fold(0.0, (sum, t) {
          return t.tipo == TipoTransaccion.Ingreso
              ? sum + t.monto
              : sum - t.monto;
        });
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
