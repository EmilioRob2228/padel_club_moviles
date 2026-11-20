import 'package:flutter/material.dart';
import 'package:padel_club/components/boton_carga.dart';
import 'package:padel_club/providers/login_provider.dart';
import 'package:provider/provider.dart';

class RecuperarScreen extends StatefulWidget {
  const RecuperarScreen({super.key});

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  final conUser = TextEditingController();

  @override
  void dispose() {
    conUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    final btnEnviar = BotonCarga(
      texto: 'Enviar enlace',
      cargando: loginProvider.cargando,
      onPressed: () async {
        final enviado = await loginProvider.m_recuperar(conUser.text.trim());
        if (!context.mounted) return;
        if (enviado) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Revisa tu correo para cambiar la contraseña')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo enviar, revisa el correo')),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Escribe tu correo y te enviaremos un enlace para crear una nueva contraseña.'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: conUser,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  btnEnviar,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
