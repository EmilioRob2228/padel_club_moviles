import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:padel_club/components/boton_carga.dart';
import 'package:padel_club/models/plan_model.dart';
import 'package:padel_club/providers/pago_provider.dart';
import 'package:provider/provider.dart';

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final conTarjeta = CardFormEditController();

  @override
  void dispose() {
    conTarjeta.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = ModalRoute.of(context)!.settings.arguments as PlanModel;
    final pagoProvider = Provider.of<PagoProvider>(context);
    final colores = Theme.of(context).colorScheme;

    Widget fila(String etiqueta, String valor, {bool total = false}) {
      final estilo = total
          ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)
          : Theme.of(context).textTheme.bodyLarge;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(etiqueta, style: total ? estilo : estilo?.copyWith(color: colores.onSurfaceVariant)),
            const Spacer(),
            Text(valor, style: estilo),
          ],
        ),
      );
    }

    final btnPagar = BotonCarga(
      texto: 'Pagar \$${plan.precio.toStringAsFixed(0)} MXN',
      cargando: pagoProvider.cargando,
      onPressed: () async {
        if (!conTarjeta.details.complete) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Completa los datos de la tarjeta')),
          );
          return;
        }
        final error = await pagoProvider.m_pagar(plan);
        if (!context.mounted) return;
        if (error == null) {
          Navigator.pushReplacementNamed(context, '/pagoExitoso', arguments: plan);
        } else if (error != 'cancelado') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Pago')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Resumen', style: TextStyle(color: colores.onSurfaceVariant)),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      children: [
                        fila('Membresía', plan.nombre),
                        fila('Periodo', '1 mes'),
                        const Divider(height: 24),
                        fila('Total', '\$${plan.precio.toStringAsFixed(0)} MXN', total: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Tarjeta', style: TextStyle(color: colores.onSurfaceVariant)),
                const SizedBox(height: 8),
                CardFormField(
                  controller: conTarjeta,
                  enablePostalCode: false,
                  countryCode: 'MX',
                  style: CardFormStyle(
                    backgroundColor: colores.surfaceContainerHighest,
                    textColor: colores.onSurface,
                    placeholderColor: colores.onSurfaceVariant,
                    borderColor: Colors.transparent,
                    borderRadius: 18,
                    cursorColor: colores.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.fingerprint, size: 18, color: colores.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Se pedirá tu huella para confirmar el pago.',
                        style: TextStyle(color: colores.onSurfaceVariant, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                btnPagar,
                const SizedBox(height: 12),
                Text(
                  'Modo de prueba: usa la tarjeta 4242 4242 4242 4242, cualquier fecha futura y cualquier CVC.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colores.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
