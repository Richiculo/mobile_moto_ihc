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

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    // TODO: Implementar cuando backend esté listo
    // final response = await http.post(
    //   Uri.parse('$baseUrl${Constants.loginEndpoint}'),
    //   headers: _getHeaders(),
    //   body: jsonEncode({'email': email, 'password': password}),
    // ).timeout(Constants.apiTimeout);

    // if (response.statusCode == 200) {
    //   return jsonDecode(response.body) as Map<String, dynamic>;
    // } else {
    //   throw Exception('Error en login: ${response.statusCode}');
    // }

    // Mock response por ahora
    await Future.delayed(const Duration(seconds: 1));
    return {
      'token': 'mock_token_12345',
      'user': {'id': 'user_1', 'name': 'Adolf Hitler', 'email': email},
    };
  }

  // Obtener pedidos
  Future<List<Pedido>> obtenerPedidos({String? estado}) async {
    // TODO: Implementar cuando backend esté listo
    // final url = estado != null
    //     ? '$baseUrl${Constants.ventasEndpoint}?estado=$estado'
    //     : '$baseUrl${Constants.ventasEndpoint}';
    //
    // final response = await http.get(
    //   Uri.parse(url),
    //   headers: _getHeaders(),
    // ).timeout(Constants.apiTimeout);

    // if (response.statusCode == 200) {
    //   final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    //   return data.map((json) => Pedido.fromJson(json as Map<String, dynamic>)).toList();
    // } else {
    //   throw Exception('Error obteniendo pedidos: ${response.statusCode}');
    // }

    // Mock response por ahora
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  // Actualizar estado de pedido
  Future<Pedido> actualizarEstadoPedido(
    String pedidoId,
    String nuevoEstado,
  ) async {
    // TODO: Implementar cuando backend esté listo
    // final response = await http.patch(
    //   Uri.parse('$baseUrl${Constants.ventasEndpoint}/$pedidoId'),
    //   headers: _getHeaders(),
    //   body: jsonEncode({'estado': nuevoEstado}),
    // ).timeout(Constants.apiTimeout);

    // if (response.statusCode == 200) {
    //   return Pedido.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // } else {
    //   throw Exception('Error actualizando pedido: ${response.statusCode}');
    // }

    // Mock response por ahora
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError('Backend no conectado aún');
  }

  // Obtener detalle de pedido
  Future<Pedido> obtenerDetallePedido(String pedidoId) async {
    // TODO: Implementar cuando backend esté listo
    // final response = await http.get(
    //   Uri.parse('$baseUrl${Constants.ventasEndpoint}/$pedidoId'),
    //   headers: _getHeaders(),
    // ).timeout(Constants.apiTimeout);

    // if (response.statusCode == 200) {
    //   return Pedido.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // } else {
    //   throw Exception('Error obteniendo detalle: ${response.statusCode}');
    // }

    // Mock response por ahora
    await Future.delayed(const Duration(milliseconds: 300));
    throw UnimplementedError('Backend no conectado aún');
  }
}
