import 'package:flutter/material.dart';
import 'package:padel_club/components/boton_carga.dart';
import 'package:padel_club/providers/login_provider.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final conNombre = TextEditingController();
  final conUser = TextEditingController();
  final conPwd = TextEditingController();
  final conPwd2 = TextEditingController();

  @override
  void dispose() {
    conNombre.dispose();
    conUser.dispose();
    conPwd.dispose();
    conPwd2.dispose();
    super.dispose();
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    final btnRegistro = BotonCarga(
      texto: 'Crear cuenta',
      cargando: loginProvider.cargando,
      onPressed: () async {
        if (conNombre.text.trim().isEmpty || conUser.text.trim().isEmpty) {
          _aviso('Llena todos los campos');
          return;
        }
        if (conPwd.text != conPwd2.text) {
          _aviso('Las contraseñas no coinciden');
          return;
        }
        final resultado = await loginProvider.m_registro(conNombre.text.trim(), conUser.text.trim(), conPwd.text);
        if (!context.mounted) return;
        if (resultado == null) {
          Navigator.pushReplacementNamed(context, '/verificar');
        } else {
          _aviso(resultado);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: conNombre,
                    decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: conUser,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: conPwd,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: conPwd2,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirmar contraseña', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  btnRegistro,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
