import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/components/fechas.dart';
import 'package:padel_club/config/firestore_reservas.dart';
import 'package:padel_club/config/huella.dart';
import 'package:padel_club/models/cancha_model.dart';
import 'package:padel_club/models/reserva_model.dart';
import 'package:padel_club/models/sede_model.dart';

class ReservaProvider extends ChangeNotifier {
  final FirestoreReservas _reservas = FirestoreReservas();
  final Huella _huella = Huella();

  DateTime fecha = DateTime.now();
  int? hora;
  bool cargando = false;

  void m_reiniciar() {
    fecha = DateTime.now();
    hora = null;
  }

  void m_elegirFecha(DateTime nueva) {
    fecha = nueva;
    hora = null;
    notifyListeners();
  }

  void m_elegirHora(int nueva) {
    hora = nueva;
    notifyListeners();
  }

  Future<String?> m_reservar(SedeModel sede, CanchaModel cancha) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null || hora == null) return 'Elige un horario';

    final huella = await _huella.m_autenticar('Confirma tu reserva en ${sede.nombre}');
    if (huella != null) return huella;

    cargando = true;
    notifyListeners();
    final error = await _reservas.m_insert(
      ReservaModel(
        id: '',
        canchaId: cancha.id,
        canchaNombre: cancha.nombre,
        sedeId: sede.id,
        sedeNombre: sede.nombre,
        uid: usuario.uid,
        fecha: Fechas.clave(fecha),
        horaInicio: hora!,
        horaFin: hora! + 1,
        monto: cancha.tarifaHora,
        estado: 'confirmada',
      ),
    );
    cargando = false;
    if (error == null) hora = null;
    notifyListeners();
    return error;
  }

  Future<bool> m_cancelar(String id) => _reservas.m_delete(id);
}
