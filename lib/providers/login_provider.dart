import 'package:flutter/material.dart';
import 'package:padel_club/config/email_auth.dart';
import 'package:padel_club/config/social_auth.dart';

class LoginProvider extends ChangeNotifier {
  final EmailAuth _emailAuth = EmailAuth();
  final SocialAuth _socialAuth = SocialAuth();
  bool cargando = false;

  void _cargando(bool valor) {
    cargando = valor;
    notifyListeners();
  }

  Future<String?> m_login(String user, String pass) async {
    _cargando(true);
    final resultado = await _emailAuth.m_loginUser(user: user, pass: pass);
    _cargando(false);
    return resultado;
  }

  Future<String?> m_registro(String nombre, String user, String pass) async {
    _cargando(true);
    final resultado = await _emailAuth.m_creaUsuario(nombre: nombre, user: user, pass: pass);
    _cargando(false);
    return resultado;
  }

  Future<bool> m_reenviar() async {
    _cargando(true);
    final resultado = await _emailAuth.m_reenviarCorreo();
    _cargando(false);
    return resultado;
  }

  Future<bool> m_verificado() async {
    _cargando(true);
    final resultado = await _emailAuth.m_verificado();
    _cargando(false);
    return resultado;
  }

  Future<bool> m_recuperar(String user) async {
    _cargando(true);
    final resultado = await _emailAuth.m_recuperar(user: user);
    _cargando(false);
    return resultado;
  }

  Future<String?> m_google() async {
    _cargando(true);
    final resultado = await _socialAuth.m_google();
    _cargando(false);
    return resultado;
  }

  Future<String?> m_github() async {
    _cargando(true);
    final resultado = await _socialAuth.m_github();
    _cargando(false);
    return resultado;
  }

  Future<void> m_cerrarSesion() async {
    await _socialAuth.m_cerrarSesion();
    await _emailAuth.m_cerrarSesion();
  }
}
