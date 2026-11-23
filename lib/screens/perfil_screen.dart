import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padel_club/components/avatar_usuario.dart';
import 'package:padel_club/providers/topics_provider.dart';
import 'package:padel_club/providers/usuario_provider.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    Future<void> cambiarFoto(ImageSource origen) async {
      Navigator.pop(context);
      final subida = await usuarioProvider.m_cambiarFoto(origen);
      if (!context.mounted) return;
      if (subida) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto actualizada')));
      }
    }

    void elegirOrigen() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Tomar foto'),
                  onTap: () => cambiarFoto(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Elegir de la galería'),
                  onTap: () => cambiarFoto(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AvatarUsuario(fotoUrl: usuarioProvider.fotoUrl, nombre: usuarioProvider.nombre, radio: 56),
                      if (usuarioProvider.subiendo) const CircularProgressIndicator(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (usuarioProvider.esCorreo)
                    TextButton.icon(
                      onPressed: usuarioProvider.subiendo ? null : elegirOrigen,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Cambiar foto'),
                    ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Nombre'),
                    subtitle: Text(usuarioProvider.nombre),
                  ),
                  ListTile(
                    leading: const Icon(Icons.mail_outline),
                    title: const Text('Correo'),
                    subtitle: Text(usuarioProvider.correo),
                  ),
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: const Text('Método de acceso'),
                    subtitle: Text(usuarioProvider.proveedor),
                  ),
                  const SizedBox(height: 24),
                  Consumer<TopicsProvider>(
                    builder: (context, topicsProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Avisos de sedes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          ),
                          ...TopicsProvider.sedes.entries.map(
                            (sede) => SwitchListTile(
                              title: Text(sede.value),
                              value: topicsProvider.topics.contains(sede.key),
                              onChanged: (activo) => topicsProvider.m_cambiarSede(sede.key, activo),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Mi nivel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 8,
                              children: TopicsProvider.niveles.entries
                                  .map(
                                    (nivel) => ChoiceChip(
                                      label: Text(nivel.value),
                                      selected: topicsProvider.nivel == nivel.key,
                                      showCheckmark: false,
                                      onSelected: (_) => topicsProvider.m_cambiarNivel(nivel.key),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
