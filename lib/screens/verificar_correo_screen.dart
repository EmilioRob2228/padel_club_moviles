import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:padel_club/providers/login_provider.dart';
import 'package:provider/provider.dart';

class VerificarCorreoScreen extends StatelessWidget {
  const VerificarCorreoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final correo = FirebaseAuth.instance.currentUser?.email ?? '';

    void aviso(String texto) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verifica tu correo')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.mark_email_unread_outlined, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Te enviamos un enlace de verificación a $correo. Ábrelo y después presiona "Ya verifiqué".',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: loginProvider.cargando
                          ? null
                          : () async {
                              final verificado = await loginProvider.m_verificado();
                              if (!context.mounted) return;
                              if (verificado) {
                                Navigator.pushNamedAndRemoveUntil(context, '/dash', (route) => false);
                              } else {
                                aviso('Todavía no has verificado tu correo');
                              }
                            },
                      child: const Text('Ya verifiqué'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: loginProvider.cargando
                          ? null
                          : () async {
                              final enviado = await loginProvider.m_reenviar();
                              if (!context.mounted) return;
                              aviso(enviado ? 'Correo reenviado' : 'Espera un momento antes de reenviar');
                            },
                      child: const Text('Reenviar correo'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () async {
                      await loginProvider.m_cerrarSesion();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    child: const Text('Volver al inicio de sesión'),
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
