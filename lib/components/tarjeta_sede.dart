import 'package:flutter/material.dart';
import 'package:padel_club/components/foto_red.dart';
import 'package:padel_club/models/sede_model.dart';

class TarjetaSede extends StatelessWidget {
  final SedeModel sede;
  final VoidCallback onTap;

  const TarjetaSede({super.key, required this.sede, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FotoRed(url: sede.fotoUrl, alto: 220),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sede.nombre,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '${sede.horarioApertura}:00 a ${sede.horarioCierre}:00',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
