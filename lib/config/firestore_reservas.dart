import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padel_club/models/reserva_model.dart';

class FirestoreReservas {
  FirebaseFirestore conexion = FirebaseFirestore.instance;

  CollectionReference? reservasCollection;

  FirestoreReservas() {
    reservasCollection = conexion.collection('reservas');
  }

  String m_id(String canchaId, String fecha, int hora) {
    return '${canchaId}_${fecha}_${hora.toString().padLeft(2, '0')}:00';
  }

  Future<String?> m_insert(ReservaModel reserva) async {
    final referencia = reservasCollection!.doc(m_id(reserva.canchaId, reserva.fecha, reserva.horaInicio));
    try {
      await conexion.runTransaction((transaccion) async {
        final existente = await transaccion.get(referencia);
        if (existente.exists) {
          throw Exception('ocupado');
        }
        transaccion.set(referencia, {...reserva.toMap(), 'creadaEn': FieldValue.serverTimestamp()});
      });
      return null;
    } catch (e) {
      if (e.toString().contains('ocupado')) return 'Ese horario ya fue reservado';
      return 'No se pudo hacer la reserva';
    }
  }

  Future<bool> m_delete(String id) async {
    try {
      await reservasCollection!.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> m_selectOcupadas(String canchaId, String fecha) {
    return reservasCollection!
        .where('canchaId', isEqualTo: canchaId)
        .where('fecha', isEqualTo: fecha)
        .snapshots();
  }

  Stream<QuerySnapshot> m_selectMias(String uid) {
    return reservasCollection!.where('uid', isEqualTo: uid).snapshots();
  }
}
