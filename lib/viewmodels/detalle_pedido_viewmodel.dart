import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetallePedidoViewModel extends ChangeNotifier {
  final ApiService _apiService;
  Pedido? _pedido;
  bool _isLoading = false;
  String? _errorMessage;

  DetallePedidoViewModel(this._apiService);

  Pedido? get pedido => _pedido;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setPedido(Pedido pedido) {
    _pedido = pedido;
    notifyListeners();
  }

  Future<void> cargarDetallePedido(String pedidoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cuando backend esté listo:
      // _pedido = await _apiService.obtenerDetallePedido(pedidoId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error cargando detalle: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> aceptarPedido() async {
    if (_pedido == null) return;

    try {
      _pedido = _pedido!.copyWith(estado: EstadoPedido.aceptado);
      notifyListeners();

      // Cuando backend esté listo:
      // await _apiService.actualizarEstadoPedido(_pedido!.id, 'ACEPTADO');
    } catch (e) {
      _errorMessage = 'Error aceptando pedido: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> cancelarPedido() async {
    if (_pedido == null) return;

    try {
      _pedido = _pedido!.copyWith(estado: EstadoPedido.cancelado);
      notifyListeners();

      // Cuando backend esté listo:
      // await _apiService.actualizarEstadoPedido(_pedido!.id, 'CANCELADO');
    } catch (e) {
      _errorMessage = 'Error cancelando pedido: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> marcarComoRecogido() async {
    if (_pedido == null) return;

    try {
      _pedido = _pedido!.copyWith(estado: EstadoPedido.recogido);
      notifyListeners();

      // Cuando backend esté listo:
      // await _apiService.actualizarEstadoPedido(_pedido!.id, 'RECOGIDO');
    } catch (e) {
      _errorMessage = 'Error actualizando estado: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> marcarEnCamino() async {
    if (_pedido == null) return;

    try {
      _pedido = _pedido!.copyWith(estado: EstadoPedido.enCamino);
      notifyListeners();

      // Cuando backend esté listo:
      // await _apiService.actualizarEstadoPedido(_pedido!.id, 'EN_CAMINO');
    } catch (e) {
      _errorMessage = 'Error actualizando estado: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> marcarComoEntregado() async {
    if (_pedido == null) return;

    try {
      _pedido = _pedido!.copyWith(estado: EstadoPedido.entregado);
      notifyListeners();

      // Cuando backend esté listo:
      // await _apiService.actualizarEstadoPedido(_pedido!.id, 'ENTREGADO');
    } catch (e) {
      _errorMessage = 'Error actualizando estado: ${e.toString()}';
      notifyListeners();
    }
  }

  // Acciones de contacto
  Future<void> llamarCliente() async {
    if (_pedido == null) return;

    final Uri phoneUri = Uri(scheme: 'tel', path: _pedido!.cliente.telefono);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _errorMessage = 'No se pudo abrir la aplicación de teléfono';
      notifyListeners();
    }
  }

  Future<void> enviarWhatsApp() async {
    if (_pedido == null) return;

    // Limpiar el número de teléfono
    final phone = _pedido!.cliente.telefono.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$phone');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      _errorMessage = 'No se pudo abrir WhatsApp';
      notifyListeners();
    }
  }

  Future<void> abrirEnGoogleMaps() async {
    if (_pedido == null) return;

    // Por ahora solo abre Google Maps, sin coordenadas específicas
    final Uri mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_pedido!.direccionEntrega)}',
    );

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    } else {
      _errorMessage = 'No se pudo abrir Google Maps';
      notifyListeners();
    }
  }

  int get progresoActual {
    if (_pedido == null) return 0;

    switch (_pedido!.estado) {
      case EstadoPedido.pendiente:
        return 1;
      case EstadoPedido.aceptado:
        return 2;
      case EstadoPedido.recogido:
        return 3;
      case EstadoPedido.enCamino:
        return 4;
      case EstadoPedido.entregado:
        return 5;
      case EstadoPedido.cancelado:
        return 0;
    }
  }
}
