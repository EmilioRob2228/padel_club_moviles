import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/config/firestore_planes.dart';
import 'package:padel_club/config/firestore_usuarios.dart';
import 'package:padel_club/models/plan_model.dart';

class MembresiasScreen extends StatelessWidget {
  const MembresiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestorePlanes = FirestorePlanes();
    final firestoreUsuarios = FirestoreUsuarios();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Membresías')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestoreUsuarios.m_selectUno(uid),
        builder: (context, usuarioSnap) {
          final datosUsuario = usuarioSnap.data?.data() as Map<String, dynamic>?;
          final planActual = datosUsuario?['planId'];

          return StreamBuilder<QuerySnapshot>(
            stream: firestorePlanes.m_select(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('No se pudieron cargar los planes'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final planes = snapshot.data!.docs
                  .map((doc) => PlanModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                  .toList();
              if (planes.isEmpty) {
                return const Center(child: Text('Aún no hay planes disponibles'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: planes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final plan = planes[index];
                  final esActual = plan.id == planActual;
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: esActual ? BorderSide(color: colores.primary, width: 2) : BorderSide.none,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(plan.nombre, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                              const Spacer(),
                              if (esActual)
                                Chip(
                                  label: const Text('Tu plan'),
                                  backgroundColor: colores.primary,
                                  labelStyle: TextStyle(color: colores.onPrimary, fontWeight: FontWeight.w700),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$${plan.precio.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                TextSpan(text: ' MXN / mes', style: TextStyle(color: colores.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...plan.beneficios.map(
                            (b) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, size: 18, color: colores.primary),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(b)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: esActual ? null : () => Navigator.pushNamed(context, '/pago', arguments: plan),
                              child: Text(esActual ? 'Plan activo' : 'Elegir ${plan.nombre}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
