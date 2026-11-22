import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/config/firestore_usuarios.dart';
import 'package:padel_club/config/huella.dart';
import 'package:padel_club/config/pagos.dart';
import 'package:padel_club/models/plan_model.dart';

class PagoProvider extends ChangeNotifier {
  final Pagos _pagos = Pagos();
  final Huella _huella = Huella();
  final FirestoreUsuarios _usuarios = FirestoreUsuarios();

  bool cargando = false;
  String? idPago;

  void _cargando(bool valor) {
    cargando = valor;
    notifyListeners();
  }

  Future<String?> m_pagar(PlanModel plan) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return 'Inicia sesión para pagar';

    final huella = await _huella.m_autenticar('Confirma el pago de la membresía ${plan.nombre}');
    if (huella != null) return huella;

    _cargando(true);
    final pago = await _pagos.m_crearPago(plan.id);
    if (pago == null) {
      _cargando(false);
      return 'No se pudo iniciar el pago, intenta de nuevo';
    }

    final error = await _pagos.m_confirmar(pago['clientSecret']);
    if (error != null) {
      _cargando(false);
      return error;
    }

    idPago = pago['paymentIntentId'];
    await _pagos.m_guardarSuscripcion({
      'uid': usuario.uid,
      'planId': plan.id,
      'monto': plan.precio,
      'estado': 'pagada',
      'stripePaymentIntentId': idPago,
      'fecha': FieldValue.serverTimestamp(),
    });
    await _usuarios.m_update(usuario.uid, {
      'nombre': usuario.displayName,
      'email': usuario.email,
      'planId': plan.id,
    });
    _cargando(false);
    return null;
  }
}
