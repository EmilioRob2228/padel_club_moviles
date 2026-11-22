class ReservaModel {
  final String id;
  final String canchaId;
  final String canchaNombre;
  final String sedeId;
  final String sedeNombre;
  final String uid;
  final String fecha;
  final int horaInicio;
  final int horaFin;
  final double monto;
  final String estado;

  ReservaModel({
    required this.id,
    required this.canchaId,
    required this.canchaNombre,
    required this.sedeId,
    required this.sedeNombre,
    required this.uid,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.monto,
    required this.estado,
  });

  factory ReservaModel.fromMap(String id, Map<String, dynamic> map) {
    return ReservaModel(
      id: id,
      canchaId: map['canchaId'] ?? '',
      canchaNombre: map['canchaNombre'] ?? '',
      sedeId: map['sedeId'] ?? '',
      sedeNombre: map['sedeNombre'] ?? '',
      uid: map['uid'] ?? '',
      fecha: map['fecha'] ?? '',
      horaInicio: map['horaInicio'] ?? 0,
      horaFin: map['horaFin'] ?? 0,
      monto: (map['monto'] ?? 0).toDouble(),
      estado: map['estado'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'canchaId': canchaId,
      'canchaNombre': canchaNombre,
      'sedeId': sedeId,
      'sedeNombre': sedeNombre,
      'uid': uid,
      'fecha': fecha,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'monto': monto,
      'estado': estado,
    };
  }
}
