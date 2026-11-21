import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageFotos {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> m_subirFotoPerfil({required String uid, required File foto}) async {
    try {
      final referencia = _storage.ref().child('usuarios/$uid/perfil.jpg');
      await referencia.putFile(foto, SettableMetadata(contentType: 'image/jpeg'));
      return await referencia.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
