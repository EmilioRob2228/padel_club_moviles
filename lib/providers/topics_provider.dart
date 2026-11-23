import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/config/firestore_usuarios.dart';
import 'package:padel_club/config/notificaciones.dart';

class TopicsProvider extends ChangeNotifier {
  final FirestoreUsuarios _usuarios = FirestoreUsuarios();

  static const sedes = {'sede_torreslanda': 'Sede Torres Landa', 'sede_campestre': 'Sede Campestre'};
  static const niveles = {'nivel_principiante': 'Principiante', 'nivel_intermedio': 'Intermedio', 'nivel_avanzado': 'Avanzado'};

  List<String> topics = [];

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  String? get nivel {
    for (final t in topics) {
      if (t.startsWith('nivel_')) return t;
    }
    return null;
  }

  Future<void> m_cargar() async {
    if (_uid == null) return;
    final datos = await _usuarios.m_get(_uid!);
    topics = List<String>.from(datos['topics'] ?? []);
    notifyListeners();
  }

  List<String> _combinados() {
    final n = nivel;
    if (n == null) return [];
    return topics
        .where((t) => t.startsWith('sede_'))
        .map((t) => '${t.replaceFirst('sede_', '')}_${n.replaceFirst('nivel_', '')}')
        .toList();
  }

  Future<void> _actualizarCombinados(List<String> anteriores) async {
    final nuevos = _combinados();
    for (final t in anteriores.where((t) => !nuevos.contains(t))) {
      await Notificaciones.m_desuscribir(t);
    }
    for (final t in nuevos.where((t) => !anteriores.contains(t))) {
      await Notificaciones.m_suscribir(t);
    }
  }

  Future<void> m_cambiarSede(String topic, bool activo) async {
    final anteriores = _combinados();
    if (activo) {
      topics.add(topic);
      await Notificaciones.m_suscribir(topic);
    } else {
      topics.remove(topic);
      await Notificaciones.m_desuscribir(topic);
    }
    notifyListeners();
    await _actualizarCombinados(anteriores);
    await _guardar();
  }

  Future<void> m_cambiarNivel(String topic) async {
    final anteriores = _combinados();
    final anterior = nivel;
    if (anterior != null) {
      topics.remove(anterior);
      await Notificaciones.m_desuscribir(anterior);
    }
    if (anterior != topic) {
      topics.add(topic);
      await Notificaciones.m_suscribir(topic);
    }
    notifyListeners();
    await _actualizarCombinados(anteriores);
    await _guardar();
  }

  Future<void> _guardar() async {
    if (_uid == null) return;
    await _usuarios.m_update(_uid!, {'topics': topics});
  }
}
