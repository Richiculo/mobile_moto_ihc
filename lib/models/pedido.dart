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
  final String userId;
  final String direccion;
  final double total;
  final EstadoPedido estado;
  final DateTime fechaCreacion;

  Pedido({
    required this.id,
    required this.userId,
    required this.direccion,
    required this.total,
    required this.estado,
    required this.fechaCreacion,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as String,
      userId: json['userId'] as String,
      direccion: json['direccion'] as String,
      total: (json['total'] as num).toDouble(),
      estado: _estadoFromString(json['estado'] as String),
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'direccion': direccion,
      'total': total,
      'estado': _estadoToString(estado),
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

  // Método copyWith para actualizar estado
  Pedido copyWith({
    String? id,
    String? userId,
    String? direccion,
    double? total,
    EstadoPedido? estado,
    DateTime? fechaCreacion,
  }) {
    return Pedido(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      direccion: direccion ?? this.direccion,
      total: total ?? this.total,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
