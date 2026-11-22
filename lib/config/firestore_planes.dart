import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePlanes {
  FirebaseFirestore conexion = FirebaseFirestore.instance;

  CollectionReference? planesCollection;

  FirestorePlanes() {
    planesCollection = conexion.collection('planes');
  }

  Stream<QuerySnapshot> m_select() {
    return planesCollection!.orderBy('precio').snapshots();
  }
}
