class Cliente {
  final String id;
  final String nombre;
  final String telefono;

  Cliente({required this.id, required this.nombre, required this.telefono});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'telefono': telefono};
  }
}
