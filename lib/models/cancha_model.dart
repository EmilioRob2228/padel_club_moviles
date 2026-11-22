class CanchaModel {
  final String id;
  final String sedeId;
  final String nombre;
  final String tipo;
  final double tarifaHora;
  final String fotoUrl;

  CanchaModel({
    required this.id,
    required this.sedeId,
    required this.nombre,
    required this.tipo,
    required this.tarifaHora,
    required this.fotoUrl,
  });

  factory CanchaModel.fromMap(String id, Map<String, dynamic> map) {
    return CanchaModel(
      id: id,
      sedeId: map['sedeId'] ?? '',
      nombre: map['nombre'] ?? '',
      tipo: map['tipo'] ?? '',
      tarifaHora: (map['tarifaHora'] ?? 0).toDouble(),
      fotoUrl: map['fotoUrl'] ?? '',
    );
  }
}
