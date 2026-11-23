import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@pragma('vm:entry-point')
Future<void> notificacionEnSegundoPlano(RemoteMessage mensaje) async {
  debugPrint('Aviso en segundo plano: ${mensaje.notification?.title}');
}

class Notificaciones {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final plugin = FlutterLocalNotificationsPlugin();

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static final List<Map<String, dynamic>> avisos = [];

  static Future<void> _cargarAvisos() async {
    final prefs = await SharedPreferences.getInstance();
    final guardados = prefs.getStringList('avisos') ?? [];
    avisos
      ..clear()
      ..addAll(guardados.map((a) => Map<String, dynamic>.from(jsonDecode(a))));
  }

  static Future<void> _guardarAviso(RemoteMessage mensaje) async {
    final id = mensaje.messageId ?? '${DateTime.now().millisecondsSinceEpoch}';
    if (avisos.any((a) => a['id'] == id)) return;
    avisos.insert(0, {
      'id': id,
      'titulo': mensaje.notification?.title ?? 'Aviso del club',
      'cuerpo': mensaje.notification?.body ?? '',
      'fecha': (mensaje.sentTime ?? DateTime.now()).toIso8601String(),
    });
    if (avisos.length > 30) avisos.removeRange(30, avisos.length);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('avisos', avisos.map(jsonEncode).toList());
  }

  static const _detalles = NotificationDetails(
    android: AndroidNotificationDetails(
      'avisos_club',
      'Avisos del club',
      channelDescription: 'Avisos de las sedes y del club',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(notificacionEnSegundoPlano);
    await _cargarAvisos();

    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (respuesta) => abrirAvisos(),
    );
    await plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'avisos_club',
            'Avisos del club',
            description: 'Avisos de las sedes y del club',
            importance: Importance.high,
          ),
        );

    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await _messaging.subscribeToTopic('general');
    final token = await _messaging.getToken();
    debugPrint('Token FCM: $token');

    FirebaseMessaging.onMessage.listen((mensaje) {
      _guardarAviso(mensaje);
      final titulo = mensaje.notification?.title ?? 'Aviso del club';
      final cuerpo = mensaje.notification?.body ?? '';
      plugin.show(
        id: mensaje.hashCode,
        title: titulo,
        body: cuerpo,
        notificationDetails: _detalles,
      );
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$titulo: $cuerpo'),
          action: SnackBarAction(label: 'Ver', onPressed: abrirAvisos),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((mensaje) async {
      await _guardarAviso(mensaje);
      abrirAvisos();
    });

    final inicial = await _messaging.getInitialMessage();
    if (inicial != null) {
      await _guardarAviso(inicial);
      WidgetsBinding.instance.addPostFrameCallback((_) => abrirAvisos());
    }
  }

  static void abrirAvisos() {
    navigatorKey.currentState?.pushNamed('/avisos');
  }

  static Future<void> m_suscribir(String topic) => _messaging.subscribeToTopic(topic);

  static Future<void> m_desuscribir(String topic) => _messaging.unsubscribeFromTopic(topic);
}
