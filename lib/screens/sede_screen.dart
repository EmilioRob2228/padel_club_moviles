import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/components/foto_red.dart';
import 'package:padel_club/config/firestore_sedes.dart';
import 'package:padel_club/models/cancha_model.dart';
import 'package:padel_club/models/sede_model.dart';
import 'package:padel_club/providers/reserva_provider.dart';
import 'package:provider/provider.dart';

class SedeScreen extends StatelessWidget {
  const SedeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sede = ModalRoute.of(context)!.settings.arguments as SedeModel;
    final firestoreSedes = FirestoreSedes();
    final colores = Theme.of(context).colorScheme;

    Widget tarjetaCancha(CanchaModel cancha) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Provider.of<ReservaProvider>(context, listen: false).m_reiniciar();
            Navigator.pushNamed(context, '/cancha', arguments: {'sede': sede, 'cancha': cancha});
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: colores.surfaceContainerHighest,
                  child: Icon(
                    cancha.tipo == 'Techada' ? Icons.roofing : Icons.wb_sunny_outlined,
                    color: colores.primary,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cancha.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(cancha.tipo, style: TextStyle(color: colores.onSurfaceVariant)),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${cancha.tarifaHora.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            TextSpan(text: ' / hora', style: TextStyle(color: colores.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.chevron_right)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(sede.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: FotoRed(url: sede.fotoUrl, alto: 200),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.place_outlined, size: 18, color: colores.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(child: Text(sede.direccion, style: TextStyle(color: colores.onSurfaceVariant))),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Elige una cancha', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: firestoreSedes.m_selectCanchas(sede.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
              }
              final canchas = snapshot.data!.docs
                  .map((doc) => CanchaModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                  .toList()
                ..sort((a, b) => a.nombre.compareTo(b.nombre));
              return LayoutBuilder(
                builder: (context, constraints) {
                  final columnas = constraints.maxWidth > 700 ? 2 : 1;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: canchas
                        .map((c) => SizedBox(
                              width: (constraints.maxWidth - 12 * (columnas - 1)) / columnas,
                              child: tarjetaCancha(c),
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
}
