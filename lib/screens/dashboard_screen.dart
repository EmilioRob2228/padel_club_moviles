import 'package:flutter/material.dart';
import 'package:padel_club/providers/login_provider.dart';
import 'package:padel_club/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Club de Pádel'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.oscuro ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.m_cambiar();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await loginProvider.m_cerrarSesion();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Dashboard', style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
