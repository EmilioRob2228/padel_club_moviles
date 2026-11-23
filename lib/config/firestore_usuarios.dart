import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsuarios {
  FirebaseFirestore conexion = FirebaseFirestore.instance;

  CollectionReference? usuariosCollection;

  FirestoreUsuarios() {
    usuariosCollection = conexion.collection('usuarios');
  }

  Future<bool> m_update(String uid, Map<String, dynamic> datos) async {
    try {
      await usuariosCollection!.doc(uid).set(datos, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> m_get(String uid) async {
    try {
      final doc = await usuariosCollection!.doc(uid).get();
      return (doc.data() as Map<String, dynamic>?) ?? {};
    } catch (e) {
      return {};
    }
  }

  Stream<DocumentSnapshot> m_selectUno(String uid) {
    return usuariosCollection!.doc(uid).snapshots();
  }
}
