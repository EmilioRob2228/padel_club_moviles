import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSedes {
  FirebaseFirestore conexion = FirebaseFirestore.instance;

  CollectionReference? sedesCollection;
  CollectionReference? canchasCollection;

  FirestoreSedes() {
    sedesCollection = conexion.collection('sedes');
    canchasCollection = conexion.collection('canchas');
  }

  Stream<QuerySnapshot> m_select() {
    return sedesCollection!.snapshots();
  }

  Stream<QuerySnapshot> m_selectCanchas(String sedeId) {
    return canchasCollection!.where('sedeId', isEqualTo: sedeId).snapshots();
  }
}
