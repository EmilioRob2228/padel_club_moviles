import 'package:flutter/material.dart';
import 'package:padel_club/config/notificaciones.dart';

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final avisos = Notificaciones.avisos;
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Avisos del club')),
      body: avisos.isEmpty
          ? Center(child: Text('No hay avisos nuevos', style: TextStyle(color: colores.onSurfaceVariant)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: avisos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final aviso = avisos[index];
                final hora = DateTime.parse(aviso['fecha']).toLocal();
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: colores.primary,
                      child: Icon(Icons.campaign_outlined, color: colores.onPrimary),
                    ),
                    title: Text(
                      aviso['titulo'],
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${aviso['cuerpo']}\n${hora.day}/${hora.month} ${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
