import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/utils/constants.dart';
import '../models/pedido.dart';

class ApiService {
  final String baseUrl;
  String? _authToken;

  ApiService({this.baseUrl = Constants.apiBaseUrl});

  void setAuthToken(String token) {
    _authToken = token;
  }

  Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // pal tachero

  // Actualizar ubicación del tacherito
  Future<void> actualizarUbicacionConductor(
    String conductorId,
    double latitud,
    double longitud,
  ) async {
    final response = await http
        .put(
          Uri.parse('$baseUrl/conductores/$conductorId/ubicacion'),
          headers: _getHeaders(),
          body: jsonEncode({'latitud': latitud, 'longitud': longitud}),
        )
        .timeout(Constants.apiTimeout);

    if (response.statusCode != 200) {
      throw Exception('Error actualizando ubicación: ${response.statusCode}');
    }
  }

  // Obtener pedido pendiente asignado al tacherin
  Future<Pedido?> obtenerPedidoPendiente(String conductorId) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/conductores/$conductorId/pedido-pendiente'),
          headers: _getHeaders(),
        )
        .timeout(Constants.apiTimeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Si el body está vacío, no hay pedido pendiente
      if (response.body.isEmpty || response.body == 'null') {
        return null;
      }
      try {
        final data = jsonDecode(response.body);
        if (data == null) return null;
        return Pedido.fromJson(data as Map<String, dynamic>);
      } catch (e) {
        // Si falla el parseo, asumir que no hay pedido
        return null;
      }
    } else if (response.statusCode == 404) {
      return null; // No hay pedido pendiente
    } else {
      throw Exception('Error obteniendo pedido: ${response.statusCode}');
    }
  }

  // Aceptar pedido
  Future<void> aceptarPedido(String pedidoId, String conductorId) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/pedidos/$pedidoId/aceptar'),
          headers: _getHeaders(),
          body: jsonEncode({'conductorId': conductorId}),
        )
        .timeout(Constants.apiTimeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error aceptando pedido: ${response.statusCode}');
    }
  }

  // Rechazar pedido
  Future<void> rechazarPedido(String pedidoId, String conductorId) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/pedidos/$pedidoId/rechazar'),
          headers: _getHeaders(),
          body: jsonEncode({'conductorId': conductorId}),
        )
        .timeout(Constants.apiTimeout);

    if (response.statusCode != 200) {
      throw Exception('Error rechazando pedido: ${response.statusCode}');
    }
  }

  // Iniciar viaje
  Future<void> iniciarViaje(String pedidoId, String conductorId) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/pedidos/$pedidoId/iniciar-viaje'),
          headers: _getHeaders(),
          body: jsonEncode({'conductorId': conductorId}),
        )
        .timeout(Constants.apiTimeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error iniciando viaje: ${response.statusCode}');
    }
  }

  // Entregar pedido
  Future<void> entregarPedido(String pedidoId, String conductorId) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/pedidos/$pedidoId/entregar'),
          headers: _getHeaders(),
          body: jsonEncode({'conductorId': conductorId}),
        )
        .timeout(Constants.apiTimeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error entregando pedido: ${response.statusCode}');
    }
  }
}
