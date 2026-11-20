import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class EmailAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> m_creaUsuario({required String nombre, required String user, required String pass}) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(email: user, password: pass);
      await credentials.user!.updateDisplayName(nombre);
      await credentials.user!.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      return _mensaje(e);
    } catch (e) {
      debugPrint('$e');
      return 'Ocurrió un error, intenta de nuevo';
    }
  }

  Future<String?> m_loginUser({required String user, required String pass}) async {
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(email: user, password: pass);
      if (credentials.user!.emailVerified) {
        return null;
      } else {
        return 'no_verificado';
      }
    } on FirebaseAuthException catch (e) {
      return _mensaje(e);
    } catch (e) {
      debugPrint('$e');
      return 'Ocurrió un error, intenta de nuevo';
    }
  }

  Future<bool> m_reenviarCorreo() async {
    try {
      await _firebaseAuth.currentUser!.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> m_verificado() async {
    try {
      await _firebaseAuth.currentUser!.reload();
      return _firebaseAuth.currentUser!.emailVerified;
    } catch (e) {
      return false;
    }
  }

  Future<bool> m_recuperar({required String user}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> m_cerrarSesion() async {
    await _firebaseAuth.signOut();
  }

  String _mensaje(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Ese correo ya tiene una cuenta';
      case 'invalid-email':
        return 'El correo no es válido';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Correo o contraseña incorrectos';
      case 'too-many-requests':
        return 'Demasiados intentos, espera un momento';
      default:
        return 'Ocurrió un error (${e.code})';
    }
  }
}
