import 'package:flutter/material.dart';

class BotonCarga extends StatelessWidget {
  final String texto;
  final bool cargando;
  final VoidCallback onPressed;

  const BotonCarga({super.key, required this.texto, required this.cargando, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: cargando ? null : onPressed,
        child: cargando
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(texto),
      ),
    );
  }
}
