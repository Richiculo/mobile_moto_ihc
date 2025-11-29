class Producto {
  final String id;
  final String nombre;
  final int cantidad;
  final double precio;

  Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      cantidad: json['cantidad'] as int,
      precio: (json['precio'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'cantidad': cantidad, 'precio': precio};
  }

  double get subtotal => cantidad * precio;
}
