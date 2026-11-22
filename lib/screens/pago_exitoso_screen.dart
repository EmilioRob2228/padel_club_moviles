import 'package:flutter/material.dart';
import 'package:padel_club/models/plan_model.dart';
import 'package:padel_club/providers/pago_provider.dart';
import 'package:provider/provider.dart';

class PagoExitosoScreen extends StatelessWidget {
  const PagoExitosoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = ModalRoute.of(context)!.settings.arguments as PlanModel;
    final idPago = Provider.of<PagoProvider>(context, listen: false).idPago ?? '';
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: colores.primary,
                    child: Icon(Icons.check_rounded, size: 52, color: colores.onPrimary),
                  ),
                  const SizedBox(height: 20),
                  const Text('Pago exitoso'),
                  const SizedBox(height: 4),
                  Text(
                    '\$${plan.precio.toStringAsFixed(0)} MXN',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _fila(context, 'Membresía', plan.nombre),
                          _fila(context, 'Estado', 'Pagada'),
                          _fila(context, 'ID de pago', idPago.length > 14 ? '...${idPago.substring(idPago.length - 14)}' : idPago),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dash', (route) => false),
                      child: const Text('Volver al inicio'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fila(BuildContext context, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(etiqueta, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const Spacer(),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
