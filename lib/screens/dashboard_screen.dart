import 'package:flutter/material.dart';
import 'package:padel_club/components/avatar_usuario.dart';
import 'package:padel_club/providers/login_provider.dart';
import 'package:padel_club/providers/theme_provider.dart';
import 'package:padel_club/providers/usuario_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Club de Pádel')),
      endDrawer: Drawer(
        child: Column(
          children: [
            Consumer<UsuarioProvider>(
              builder: (context, usuarioProvider, child) {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer),
                  accountName: Text(
                    usuarioProvider.nombre,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700),
                  ),
                  accountEmail: Text(
                    usuarioProvider.correo,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  currentAccountPicture: AvatarUsuario(
                    fotoUrl: usuarioProvider.fotoUrl,
                    nombre: usuarioProvider.nombre,
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Mi perfil'),
              subtitle: const Text('Datos y foto'),
              leading: const Icon(Icons.person_outline),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/perfil');
              },
            ),
            ListTile(
              title: const Text('Membresías'),
              subtitle: const Text('Planes y pago'),
              leading: const Icon(Icons.workspace_premium_outlined),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/membresias');
              },
            ),
            SwitchListTile(
              title: const Text('Tema oscuro'),
              secondary: const Icon(Icons.dark_mode_outlined),
              value: themeProvider.oscuro,
              onChanged: (valor) {
                themeProvider.m_cambiar();
              },
            ),
            const Spacer(),
            ListTile(
              title: const Text('Cerrar sesión'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                await loginProvider.m_cerrarSesion();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: Consumer<UsuarioProvider>(
        builder: (context, usuarioProvider, child) {
          return Center(
            child: Text(
              'Hola, ${usuarioProvider.nombre}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        },
      ),
    );
  }
}
