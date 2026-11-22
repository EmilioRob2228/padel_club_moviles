import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/components/boton_carga.dart';
import 'package:padel_club/components/fechas.dart';
import 'package:padel_club/components/foto_red.dart';
import 'package:padel_club/config/firestore_reservas.dart';
import 'package:padel_club/models/cancha_model.dart';
import 'package:padel_club/models/sede_model.dart';
import 'package:padel_club/providers/reserva_provider.dart';
import 'package:provider/provider.dart';

class CanchaDetalleScreen extends StatelessWidget {
  const CanchaDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final SedeModel sede = argumentos['sede'];
    final CanchaModel cancha = argumentos['cancha'];
    final reservaProvider = Provider.of<ReservaProvider>(context);
    final firestoreReservas = FirestoreReservas();
    final colores = Theme.of(context).colorScheme;
    final altoFoto = MediaQuery.of(context).size.height * 0.45;

    final hoy = DateTime.now();
    final dias = List.generate(7, (i) => DateTime(hoy.year, hoy.month, hoy.day + i));
    final fechaClave = Fechas.clave(reservaProvider.fecha);
    final esHoy = fechaClave == Fechas.clave(hoy);
    final horas = List.generate(sede.horarioCierre - sede.horarioApertura, (i) => sede.horarioApertura + i);

    Widget chipDia(DateTime dia) {
      final elegido = Fechas.clave(dia) == fechaClave;
      return GestureDetector(
        onTap: () => reservaProvider.m_elegirFecha(dia),
        child: Container(
          width: 64,
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: elegido ? colores.primary : colores.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                Fechas.dias[dia.weekday - 1],
                style: TextStyle(color: elegido ? colores.onPrimary : colores.onSurfaceVariant, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                '${dia.day}',
                style: TextStyle(
                  color: elegido ? colores.onPrimary : colores.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget chipHora(int hora, bool ocupada) {
      final pasada = esHoy && hora <= hoy.hour;
      final disponible = !ocupada && !pasada;
      final elegida = reservaProvider.hora == hora;
      return GestureDetector(
        onTap: disponible ? () => reservaProvider.m_elegirHora(hora) : null,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: elegida ? colores.primary : colores.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Text(
            ocupada ? 'Ocupada' : Fechas.hora(hora),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: elegida
                  ? colores.onPrimary
                  : disponible
                      ? colores.onSurface
                      : colores.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    final btnReservar = BotonCarga(
      texto: reservaProvider.hora == null
          ? 'Elige un horario'
          : 'Reservar ${Fechas.hora(reservaProvider.hora!)} · \$${cancha.tarifaHora.toStringAsFixed(0)}',
      cargando: reservaProvider.cargando,
      onPressed: () async {
        if (reservaProvider.hora == null) return;
        final error = await reservaProvider.m_reservar(sede, cancha);
        if (!context.mounted) return;
        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reserva confirmada')));
          Navigator.pushNamedAndRemoveUntil(context, '/misReservas', ModalRoute.withName('/dash'));
        } else if (error != 'cancelado') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        }
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: altoFoto, width: double.infinity, child: FotoRed(url: sede.fotoUrl, alto: altoFoto)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colores.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cancha.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                              Text('${sede.nombre} · ${cancha.tipo}', style: TextStyle(color: colores.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\$${cancha.tarifaHora.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                              ),
                              TextSpan(text: ' /hora', style: TextStyle(color: colores.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Día', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 76,
                      child: ListView(scrollDirection: Axis.horizontal, children: dias.map(chipDia).toList()),
                    ),
                    const SizedBox(height: 24),
                    const Text('Horario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestoreReservas.m_selectOcupadas(cancha.id, fechaClave),
                      builder: (context, snapshot) {
                        final ocupadas = (snapshot.data?.docs ?? [])
                            .map((d) => (d.data() as Map<String, dynamic>)['horaInicio'] as int)
                            .toSet();
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final columnas = constraints.maxWidth > 600 ? 5 : 3;
                            return GridView.count(
                              crossAxisCount: columnas,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 2.4,
                              children: horas.map((h) => chipHora(h, ocupadas.contains(h))).toList(),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    btnReservar,
                    const SizedBox(height: 8),
                    Text(
                      'Confirmas con tu huella. El pago se hace en el club.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colores.onSurfaceVariant, fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
