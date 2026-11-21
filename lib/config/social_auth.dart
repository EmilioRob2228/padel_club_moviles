import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:padel_club/firebase_options.dart';

class SocialAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static bool _googleIniciado = false;

  Future<void> _iniciarGoogle() async {
    if (_googleIniciado) return;
    await GoogleSignIn.instance.initialize(
      clientId: defaultTargetPlatform == TargetPlatform.iOS ? DefaultFirebaseOptions.currentPlatform.iosClientId : null,
    );
    _googleIniciado = true;
  }

  Future<String?> m_google() async {
    try {
      await _iniciarGoogle();
      final cuenta = await GoogleSignIn.instance.authenticate();
      final credencial = GoogleAuthProvider.credential(idToken: cuenta.authentication.idToken);
      await _firebaseAuth.signInWithCredential(credencial);
      return null;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return 'cancelado';
      debugPrint('$e');
      return 'No se pudo iniciar sesión con Google';
    } on FirebaseAuthException catch (e) {
      return _mensaje(e);
    } catch (e) {
      debugPrint('$e');
      return 'No se pudo iniciar sesión con Google';
    }
  }

  Future<String?> m_github() async {
    try {
      await _firebaseAuth.signInWithProvider(GithubAuthProvider());
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'canceled' || e.code == 'web-context-canceled') return 'cancelado';
      return _mensaje(e);
    } catch (e) {
      debugPrint('$e');
      return 'No se pudo iniciar sesión con GitHub';
    }
  }

  Future<void> m_cerrarSesion() async {
    try {
      await _iniciarGoogle();
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      debugPrint('$e');
    }
  }

  String _mensaje(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'Ese correo ya está registrado con otro método de acceso';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada';
      default:
        return 'Ocurrió un error (${e.code})';
    }
  }
}
