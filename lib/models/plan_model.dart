class PlanModel {
  final String id;
  final String nombre;
  final double precio;
  final List<String> beneficios;

  PlanModel({required this.id, required this.nombre, required this.precio, required this.beneficios});

  factory PlanModel.fromMap(String id, Map<String, dynamic> map) {
    return PlanModel(
      id: id,
      nombre: map['nombre'] ?? '',
      precio: (map['precio'] ?? 0).toDouble(),
      beneficios: List<String>.from(map['beneficios'] ?? []),
    );
  }
}
