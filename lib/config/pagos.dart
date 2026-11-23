import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class Pagos {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final CollectionReference _suscripciones = FirebaseFirestore.instance.collection('suscripciones');

  Future<Map<String, dynamic>?> m_crearPago(String planId) async {
    try {
      final resultado = await _functions.httpsCallable('crearPagoMembresia').call({'planId': planId});
      return Map<String, dynamic>.from(resultado.data);
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<String?> m_confirmar(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'House of Padel',
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: Color(0xFFDFF94B)),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(background: Color(0xFFDFF94B), text: Color(0xFF0B0B0C)),
                dark: PaymentSheetPrimaryButtonThemeColors(background: Color(0xFFDFF94B), text: Color(0xFF0B0B0C)),
              ),
            ),
          ),
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      return null;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return 'cancelado';
      return e.error.localizedMessage ?? 'El pago fue rechazado';
    } catch (e) {
      debugPrint('$e');
      return 'No se pudo completar el pago';
    }
  }

  Future<String?> m_guardarSuscripcion(Map<String, dynamic> suscripcion) async {
    try {
      final doc = await _suscripciones.add(suscripcion);
      return doc.id;
    } catch (e) {
      return null;
    }
  }
}
