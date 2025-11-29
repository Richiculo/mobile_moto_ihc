import 'cliente.dart';
import 'producto.dart';

enum EstadoPedido {
  pendiente,
  aceptado,
  recogido,
  enCamino,
  entregado,
  cancelado,
}

class Pedido {
  final String id;
  final String codigo; // CE-2025-001
  final Cliente cliente;
  final String direccionEntrega;
  final String? direccionRecogida;
  final List<Producto> productos;
  final double total;
  final EstadoPedido estado;
  final int tiempoEstimado; // en minutos
  final double? distancia; // en km
  final String? notasEspeciales;
  final DateTime fechaCreacion;

  Pedido({
    required this.id,
    required this.codigo,
    required this.cliente,
    required this.direccionEntrega,
    this.direccionRecogida,
    required this.productos,
    required this.total,
    required this.estado,
    required this.tiempoEstimado,
    this.distancia,
    this.notasEspeciales,
    required this.fechaCreacion,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as String,
      codigo: json['codigo'] as String,
      cliente: Cliente.fromJson(json['cliente'] as Map<String, dynamic>),
      direccionEntrega: json['direccionEntrega'] as String,
      direccionRecogida: json['direccionRecogida'] as String?,
      productos:
          (json['productos'] as List)
              .map((p) => Producto.fromJson(p as Map<String, dynamic>))
              .toList(),
      total: (json['total'] as num).toDouble(),
      estado: _estadoFromString(json['estado'] as String),
      tiempoEstimado: json['tiempoEstimado'] as int,
      distancia:
          json['distancia'] != null
              ? (json['distancia'] as num).toDouble()
              : null,
      notasEspeciales: json['notasEspeciales'] as String?,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'cliente': cliente.toJson(),
      'direccionEntrega': direccionEntrega,
      'direccionRecogida': direccionRecogida,
      'productos': productos.map((p) => p.toJson()).toList(),
      'total': total,
      'estado': _estadoToString(estado),
      'tiempoEstimado': tiempoEstimado,
      'distancia': distancia,
      'notasEspeciales': notasEspeciales,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  static EstadoPedido _estadoFromString(String estado) {
    switch (estado.toUpperCase()) {
      case 'PENDIENTE':
        return EstadoPedido.pendiente;
      case 'ACEPTADO':
        return EstadoPedido.aceptado;
      case 'RECOGIDO':
        return EstadoPedido.recogido;
      case 'EN_CAMINO':
        return EstadoPedido.enCamino;
      case 'ENTREGADO':
        return EstadoPedido.entregado;
      case 'CANCELADO':
        return EstadoPedido.cancelado;
      default:
        return EstadoPedido.pendiente;
    }
  }

  static String _estadoToString(EstadoPedido estado) {
    switch (estado) {
      case EstadoPedido.pendiente:
        return 'PENDIENTE';
      case EstadoPedido.aceptado:
        return 'ACEPTADO';
      case EstadoPedido.recogido:
        return 'RECOGIDO';
      case EstadoPedido.enCamino:
        return 'EN_CAMINO';
      case EstadoPedido.entregado:
        return 'ENTREGADO';
      case EstadoPedido.cancelado:
        return 'CANCELADO';
    }
  }

  String get estadoTexto {
    switch (estado) {
      case EstadoPedido.pendiente:
        return 'Nuevo Pedido';
      case EstadoPedido.aceptado:
        return 'Aceptado';
      case EstadoPedido.recogido:
        return 'Recogido';
      case EstadoPedido.enCamino:
        return 'En Camino';
      case EstadoPedido.entregado:
        return 'Entregado';
      case EstadoPedido.cancelado:
        return 'Cancelado';
    }
  }

  int get cantidadProductos {
    return productos.fold(0, (sum, producto) => sum + producto.cantidad);
  }

  // Copia con modificaciones
  Pedido copyWith({
    String? id,
    String? codigo,
    Cliente? cliente,
    String? direccionEntrega,
    String? direccionRecogida,
    List<Producto>? productos,
    double? total,
    EstadoPedido? estado,
    int? tiempoEstimado,
    double? distancia,
    String? notasEspeciales,
    DateTime? fechaCreacion,
  }) {
    return Pedido(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      cliente: cliente ?? this.cliente,
      direccionEntrega: direccionEntrega ?? this.direccionEntrega,
      direccionRecogida: direccionRecogida ?? this.direccionRecogida,
      productos: productos ?? this.productos,
      total: total ?? this.total,
      estado: estado ?? this.estado,
      tiempoEstimado: tiempoEstimado ?? this.tiempoEstimado,
      distancia: distancia ?? this.distancia,
      notasEspeciales: notasEspeciales ?? this.notasEspeciales,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
