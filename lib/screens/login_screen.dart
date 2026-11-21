import 'package:flutter/material.dart';
import 'package:padel_club/components/boton_carga.dart';
import 'package:padel_club/providers/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final conUser = TextEditingController();
  final conPwd = TextEditingController();

  @override
  void dispose() {
    conUser.dispose();
    conPwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    final txtUser = TextFormField(
      controller: conUser,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
    );

    final txtPwd = TextFormField(
      controller: conPwd,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
    );

    final btnLogin = BotonCarga(
      texto: 'Entrar',
      cargando: loginProvider.cargando,
      onPressed: () async {
        final resultado = await loginProvider.m_login(conUser.text.trim(), conPwd.text);
        if (!context.mounted) return;
        if (resultado == null) {
          Navigator.pushReplacementNamed(context, '/dash');
        } else if (resultado == 'no_verificado') {
          Navigator.pushNamed(context, '/verificar');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultado)));
        }
      },
    );

    Future<void> social(Future<String?> Function() metodo) async {
      final resultado = await metodo();
      if (!context.mounted) return;
      if (resultado == null) {
        Navigator.pushReplacementNamed(context, '/dash');
      } else if (resultado != 'cancelado') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultado)));
      }
    }

    final btnGoogle = SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: loginProvider.cargando ? null : () => social(loginProvider.m_google),
        icon: const Icon(Icons.g_mobiledata, size: 28),
        label: const Text('Continuar con Google'),
      ),
    );

    final btnGithub = SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: loginProvider.cargando ? null : () => social(loginProvider.m_github),
        icon: const Icon(Icons.code),
        label: const Text('Continuar con GitHub'),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Club de Pádel', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  txtUser,
                  const SizedBox(height: 12),
                  txtPwd,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/recuperar'),
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  btnLogin,
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('o')),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  btnGoogle,
                  const SizedBox(height: 12),
                  btnGithub,
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signIn'),
                    child: const Text('Crear cuenta'),
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
