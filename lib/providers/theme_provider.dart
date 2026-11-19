import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool oscuro = false;

  ThemeProvider() {
    m_cargar();
  }

  ThemeMode get modo => oscuro ? ThemeMode.dark : ThemeMode.light;

  Future<void> m_cargar() async {
    final prefs = await SharedPreferences.getInstance();
    oscuro = prefs.getBool('oscuro') ?? false;
    notifyListeners();
  }

  Future<void> m_cambiar() async {
    oscuro = !oscuro;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('oscuro', oscuro);
  }
}
