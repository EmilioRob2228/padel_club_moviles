import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final String siguiente;

  const OnboardingScreen({super.key, required this.siguiente});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final conPaginas = PageController();

  static const paginas = [
    {
      'icono': Icons.sports_tennis,
      'titulo': 'Reserva tu cancha',
      'texto': 'Elige sede, cancha y horario. Ves la disponibilidad en tiempo real y nadie te gana el lugar.',
    },
    {
      'icono': Icons.workspace_premium_outlined,
      'titulo': 'Hazte miembro',
      'texto': 'Elige entre Básica, Premium o VIP y paga desde la app de forma segura con tu huella.',
    },
    {
      'icono': Icons.campaign_outlined,
      'titulo': 'Entérate de todo',
      'texto': 'Recibe avisos de torneos y clases de tus sedes favoritas y de tu nivel de juego.',
    },
  ];

  @override
  void dispose() {
    conPaginas.dispose();
    super.dispose();
  }

  Future<void> _terminar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_visto', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, widget.siguiente);
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: _terminar, child: const Text('Saltar')),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset('assets/logo.png', height: 96),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: conPaginas,
                    itemCount: paginas.length,
                    itemBuilder: (context, index) {
                      final pagina = paginas[index];
                      return Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 72,
                              backgroundColor: colores.primary,
                              child: Icon(pagina['icono'] as IconData, size: 72, color: colores.onPrimary),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              pagina['titulo'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              pagina['texto'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: colores.onSurfaceVariant),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                AnimatedBuilder(
                  animation: conPaginas,
                  builder: (context, child) {
                    final actual = conPaginas.hasClients ? (conPaginas.page ?? 0).round() : 0;
                    final ultima = actual == paginas.length - 1;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              paginas.length,
                              (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: i == actual ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: i == actual ? colores.primary : colores.outline,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: ultima
                                  ? _terminar
                                  : () => conPaginas.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      ),
                              child: Text(ultima ? 'Empezar' : 'Siguiente'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
