import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../models/cliente.dart';
import '../models/producto.dart';
import '../services/api_service.dart';

class PedidosViewModel extends ChangeNotifier {
  final ApiService _apiService;

  PedidosViewModel(this._apiService) {
    _cargarPedidosMock();
  }

  List<Pedido> _todosPedidos = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtrar pedidos por estado
  List<Pedido> get pedidosEntrantes {
    return _todosPedidos
        .where((p) => p.estado == EstadoPedido.pendiente)
        .toList();
  }

  List<Pedido> get pedidosEnCurso {
    return _todosPedidos
        .where(
          (p) =>
              p.estado == EstadoPedido.aceptado ||
              p.estado == EstadoPedido.recogido ||
              p.estado == EstadoPedido.enCamino,
        )
        .toList();
  }

  List<Pedido> get misEntregas {
    return _todosPedidos
        .where(
          (p) =>
              p.estado == EstadoPedido.entregado ||
              p.estado == EstadoPedido.cancelado,
        )
        .toList();
  }

  Future<void> cargarPedidos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _todosPedidos = await _apiService.obtenerPedidos();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error cargando pedidos: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarEstado(
    String pedidoId,
    EstadoPedido nuevoEstado,
  ) async {
    try {
      final index = _todosPedidos.indexWhere((p) => p.id == pedidoId);
      if (index != -1) {
        _todosPedidos[index] = _todosPedidos[index].copyWith(
          estado: nuevoEstado,
        );
        notifyListeners();
      }

      // Cuando backend esté listo:
      // await _apiService.actualizarEstadoPedido(pedidoId, nuevoEstado.toString());
    } catch (e) {
      _errorMessage = 'Error actualizando pedido: ${e.toString()}';
      notifyListeners();
    }
  }

  Pedido? obtenerPedidoPorId(String id) {
    try {
      return _todosPedidos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Datos mock para desarrollo
  void _cargarPedidosMock() {
    _todosPedidos = [
      // Pedidos entrantes
      Pedido(
        id: '1',
        codigo: 'CE-2025-001',
        cliente: Cliente(
          id: 'c1',
          nombre: 'María Gonzales',
          telefono: '+591 7234 5678',
        ),
        direccionEntrega: 'Av. San Martín #456, entre Calle 3 y 4',
        direccionRecogida: 'CambaEats Central - Av. Cristo Redentor #123',
        productos: [
          Producto(
            id: 'p1',
            nombre: 'Hamburguesa Completa',
            cantidad: 2,
            precio: 35.0,
          ),
          Producto(
            id: 'p2',
            nombre: 'Papas Fritas Grande',
            cantidad: 1,
            precio: 15.0,
          ),
          Producto(
            id: 'p3',
            nombre: 'Coca Cola 1.5L',
            cantidad: 1,
            precio: 10.0,
          ),
        ],
        total: 95.0,
        estado: EstadoPedido.pendiente,
        tiempoEstimado: 25,
        distancia: 0.7,
        fechaCreacion: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Pedido(
        id: '2',
        codigo: 'CE-2025-002',
        cliente: Cliente(
          id: 'c2',
          nombre: 'María Gonzales',
          telefono: '+591 7234 5678',
        ),
        direccionEntrega: 'Av. San Martín #456, entre Calle 3 y 4',
        direccionRecogida: 'CambaEats Central - Av. Cristo Redentor #123',
        productos: [
          Producto(
            id: 'p4',
            nombre: 'Hamburguesa Completa',
            cantidad: 2,
            precio: 35.0,
          ),
          Producto(
            id: 'p5',
            nombre: 'Papas Fritas Grande',
            cantidad: 1,
            precio: 15.0,
          ),
          Producto(
            id: 'p6',
            nombre: 'Coca Cola 1.5L',
            cantidad: 1,
            precio: 10.0,
          ),
        ],
        total: 95.0,
        estado: EstadoPedido.pendiente,
        tiempoEstimado: 25,
        distancia: 0.7,
        fechaCreacion: DateTime.now().subtract(const Duration(minutes: 10)),
      ),

      // Pedidos en curso
      Pedido(
        id: '3',
        codigo: 'CE-2024-005',
        cliente: Cliente(
          id: 'c3',
          nombre: 'Patricia Morales',
          telefono: '+591 7678 9012',
        ),
        direccionEntrega: 'Av. Roca y Coronado #890, Urbari',
        direccionRecogida: 'CambaEats Central - Av. Cristo Redentor #123',
        productos: [
          Producto(
            id: 'p7',
            nombre: 'Pollo Broaster Familiar',
            cantidad: 1,
            precio: 85.0,
          ),
          Producto(
            id: 'p8',
            nombre: 'Ensalada Mixta',
            cantidad: 1,
            precio: 18.0,
          ),
        ],
        total: 103.0,
        estado: EstadoPedido.aceptado,
        tiempoEstimado: 35,
        distancia: 1.2,
        fechaCreacion: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Pedido(
        id: '4',
        codigo: 'CE-2024-003',
        cliente: Cliente(
          id: 'c4',
          nombre: 'Ana Pérez',
          telefono: '+591 12312323',
        ),
        direccionEntrega: 'Av. Banzer #234, 3er Anillo',
        direccionRecogida: 'CambaEats Central - Av. Cristo Redentor #123',
        productos: [
          Producto(
            id: 'p9',
            nombre: 'Hamburguesa Americana',
            cantidad: 2,
            precio: 40.0,
          ),
        ],
        total: 80.0,
        estado: EstadoPedido.enCamino,
        tiempoEstimado: 15,
        distancia: 0.5,
        fechaCreacion: DateTime.now().subtract(const Duration(hours: 2)),
      ),

      // Entregas completadas
      Pedido(
        id: '5',
        codigo: 'CE-2024-006',
        cliente: Cliente(
          id: 'c5',
          nombre: 'Roberto Sánchez',
          telefono: '+591 7789 0123',
        ),
        direccionEntrega: 'Av. Alemana #345, 4to Anillo',
        direccionRecogida: 'CambaEats Central - Av. Cristo Redentor #123',
        productos: [
          Producto(
            id: 'p10',
            nombre: 'Hamburguesa Cangreburger',
            cantidad: 1,
            precio: 45.0,
          ),
          Producto(
            id: 'p11',
            nombre: 'Milkshake de Chocolate',
            cantidad: 1,
            precio: 25.0,
          ),
          Producto(
            id: 'p12',
            nombre: 'Papas Fritas Medianas',
            cantidad: 1,
            precio: 80.0,
          ),
        ],
        total: 150.0,
        estado: EstadoPedido.entregado,
        tiempoEstimado: 60,
        distancia: 2.5,
        fechaCreacion: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Pedido(
        id: '6',
        codigo: 'CE-2024-011',
        cliente: Cliente(
          id: 'c6',
          nombre: 'Gabriela Méndez',
          telefono: '+591 7234 5670',
        ),
        direccionEntrega: 'Calle Arenales #123, Barrio Cristo Rey',
        direccionRecogida: 'CambaEats Central - Av. Cristo Redentor #123',
        productos: [
          Producto(
            id: 'p13',
            nombre: 'Pizza Napolitana',
            cantidad: 1,
            precio: 65.0,
          ),
        ],
        total: 65.0,
        estado: EstadoPedido.cancelado,
        tiempoEstimado: 40,
        distancia: 1.8,
        notasEspeciales: 'Cliente canceló por demora',
        fechaCreacion: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
    notifyListeners();
  }
}
