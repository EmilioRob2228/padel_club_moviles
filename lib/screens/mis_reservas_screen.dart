import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/components/fechas.dart';
import 'package:padel_club/config/firestore_reservas.dart';
import 'package:padel_club/models/reserva_model.dart';
import 'package:padel_club/providers/reserva_provider.dart';
import 'package:provider/provider.dart';

class MisReservasScreen extends StatelessWidget {
  const MisReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreReservas = FirestoreReservas();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final colores = Theme.of(context).colorScheme;
    final hoy = Fechas.clave(DateTime.now());

    Future<void> cancelar(ReservaModel reserva) async {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancelar reserva'),
          content: Text('${reserva.canchaNombre}, ${Fechas.legible(reserva.fecha)} a las ${Fechas.hora(reserva.horaInicio)}'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí, cancelar')),
          ],
        ),
      );
      if (confirmar != true || !context.mounted) return;
      await Provider.of<ReservaProvider>(context, listen: false).m_cancelar(reserva.id);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mis reservas')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreReservas.m_selectMias(uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('No se pudieron cargar tus reservas'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reservas = snapshot.data!.docs
              .map((doc) => ReservaModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .where((r) => r.fecha.compareTo(hoy) >= 0)
              .toList()
            ..sort((a, b) => '${a.fecha}${a.horaInicio.toString().padLeft(2, '0')}'
                .compareTo('${b.fecha}${b.horaInicio.toString().padLeft(2, '0')}'));
          if (reservas.isEmpty) {
            return Center(
              child: Text('Aún no tienes reservas', style: TextStyle(color: colores.onSurfaceVariant)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: reservas.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = reservas[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(width: 4, height: 48, color: colores.primary),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 72,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.fecha == hoy ? 'Hoy' : Fechas.legible(r.fecha),
                                style: TextStyle(color: colores.onSurfaceVariant, fontSize: 13)),
                            Text(Fechas.hora(r.horaInicio), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.sedeNombre, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('${r.canchaNombre} · \$${r.monto.toStringAsFixed(0)} · Pago en el club',
                                style: TextStyle(color: colores.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Cancelar',
                        onPressed: () => cancelar(r),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
