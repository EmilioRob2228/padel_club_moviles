class SedeModel {
  final String id;
  final String nombre;
  final String direccion;
  final double lat;
  final double lng;
  final String fotoUrl;
  final int horarioApertura;
  final int horarioCierre;
  final String topic;

  SedeModel({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.lat,
    required this.lng,
    required this.fotoUrl,
    required this.horarioApertura,
    required this.horarioCierre,
    required this.topic,
  });

  factory SedeModel.fromMap(String id, Map<String, dynamic> map) {
    return SedeModel(
      id: id,
      nombre: map['nombre'] ?? '',
      direccion: map['direccion'] ?? '',
      lat: (map['lat'] ?? 0).toDouble(),
      lng: (map['lng'] ?? 0).toDouble(),
      fotoUrl: map['fotoUrl'] ?? '',
      horarioApertura: map['horarioApertura'] ?? 7,
      horarioCierre: map['horarioCierre'] ?? 22,
      topic: map['topic'] ?? '',
    );
  }
}
