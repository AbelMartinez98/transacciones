import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transacciones_app/domain/models/transaccion.dart';

class ApiService {
  final String baseUrl = "http://10.2.12.68:5208/api";

  // Obtener todas las transacciones
  Future<List<Transaccion>> fetchTransacciones() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/transaccion'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Transaccion.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las transacciones');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Crear una nueva transacción
  Future<Transaccion> createTransaccion(Transaccion transaccion) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transaccion'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaccion.toJson()),
      );

      if (response.statusCode == 201) {
        return Transaccion.fromJson(json.decode(response.body));
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['title'] ?? 'Error al crear la transacción');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Actualizar una transacción existente
  Future<void> updateTransaccion(int id, Transaccion transaccion) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/transaccion/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaccion.toJson()),
      );

      if (response.statusCode != 200) {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(
          errorBody['title'] ?? 'Error al actualizar la transacción',
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
