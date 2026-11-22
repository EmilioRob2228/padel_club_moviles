import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/components/avatar_usuario.dart';
import 'package:padel_club/components/tarjeta_sede.dart';
import 'package:padel_club/config/firestore_sedes.dart';
import 'package:padel_club/models/sede_model.dart';
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
              title: const Text('Mis reservas'),
              subtitle: const Text('Próximos partidos'),
              leading: const Icon(Icons.event_note_outlined),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/misReservas');
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Consumer<UsuarioProvider>(
            builder: (context, usuarioProvider, child) {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hola', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        Text(
                          usuarioProvider.nombre,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  AvatarUsuario(fotoUrl: usuarioProvider.fotoUrl, nombre: usuarioProvider.nombre, radio: 24),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _accion(context, Icons.event_note_outlined, 'Mis reservas', '/misReservas'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _accion(context, Icons.workspace_premium_outlined, 'Membresías', '/membresias'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text('Nuestras sedes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: FirestoreSedes().m_select(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('No se pudieron cargar las sedes');
              }
              if (!snapshot.hasData) {
                return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
              }
              final sedes = snapshot.data!.docs
                  .map((doc) => SedeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                  .toList();
              return LayoutBuilder(
                builder: (context, constraints) {
                  final columnas = constraints.maxWidth > 1000 ? 3 : constraints.maxWidth > 650 ? 2 : 1;
                  final ancho = (constraints.maxWidth - 16 * (columnas - 1)) / columnas;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: sedes
                        .map((sede) => SizedBox(
                              width: ancho,
                              child: TarjetaSede(
                                sede: sede,
                                onTap: () => Navigator.pushNamed(context, '/sede', arguments: sede),
                              ),
                            ))
                        .toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _accion(BuildContext context, IconData icono, String texto, String ruta) {
    final colores = Theme.of(context).colorScheme;
    return Material(
      color: colores.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, ruta),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colores.primary,
                child: Icon(icono, size: 20, color: colores.onPrimary),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(texto, style: const TextStyle(fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }
}
