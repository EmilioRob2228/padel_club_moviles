import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padel_club/config/storage_fotos.dart';

class UsuarioProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StorageFotos _storageFotos = StorageFotos();
  StreamSubscription<User?>? _suscripcion;

  User? usuario;
  bool subiendo = false;

  UsuarioProvider() {
    usuario = _firebaseAuth.currentUser;
    _suscripcion = _firebaseAuth.userChanges().listen((user) {
      usuario = user;
      notifyListeners();
    });
  }

  String get nombre => usuario?.displayName ?? 'Jugador';

  String get correo => usuario?.email ?? '';

  String? get fotoUrl {
    if (usuario?.photoURL != null) return usuario!.photoURL;
    for (final info in usuario?.providerData ?? <UserInfo>[]) {
      if (info.photoURL != null) return info.photoURL;
    }
    return null;
  }

  bool get esCorreo => usuario?.providerData.any((p) => p.providerId == 'password') ?? false;

  String get proveedor {
    final ids = usuario?.providerData.map((p) => p.providerId).toList() ?? [];
    if (ids.contains('google.com')) return 'Google';
    if (ids.contains('github.com')) return 'GitHub';
    return 'Correo y contraseña';
  }

  Future<bool> m_cambiarFoto(ImageSource origen) async {
    if (usuario == null || !esCorreo) return false;
    final imagen = await ImagePicker().pickImage(source: origen, maxWidth: 600, imageQuality: 75);
    if (imagen == null) return false;
    subiendo = true;
    notifyListeners();
    final url = await _storageFotos.m_subirFotoPerfil(uid: usuario!.uid, foto: File(imagen.path));
    if (url != null) {
      await usuario!.updatePhotoURL(url);
      await usuario!.reload();
    }
    subiendo = false;
    notifyListeners();
    return url != null;
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
