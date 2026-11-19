import 'package:flutter/material.dart';
import 'package:padel_club/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Club de Pádel'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.oscuro ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.m_cambiar();
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
