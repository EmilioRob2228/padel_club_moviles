import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:padel_club/components/theme_app.dart';
import 'package:padel_club/config/notificaciones.dart';
import 'package:padel_club/firebase_options.dart';
import 'package:padel_club/providers/login_provider.dart';
import 'package:padel_club/providers/pago_provider.dart';
import 'package:padel_club/providers/reserva_provider.dart';
import 'package:padel_club/providers/theme_provider.dart';
import 'package:padel_club/providers/topics_provider.dart';
import 'package:padel_club/providers/usuario_provider.dart';
import 'package:padel_club/screens/avisos_screen.dart';
import 'package:padel_club/screens/cancha_detalle_screen.dart';
import 'package:padel_club/screens/dashboard_screen.dart';
import 'package:padel_club/screens/login_screen.dart';
import 'package:padel_club/screens/map_screen.dart';
import 'package:padel_club/screens/onboarding_screen.dart';
import 'package:padel_club/screens/membresias_screen.dart';
import 'package:padel_club/screens/mis_reservas_screen.dart';
import 'package:padel_club/screens/pago_exitoso_screen.dart';
import 'package:padel_club/screens/pago_screen.dart';
import 'package:padel_club/screens/perfil_screen.dart';
import 'package:padel_club/screens/recuperar_screen.dart';
import 'package:padel_club/screens/sede_screen.dart';
import 'package:padel_club/screens/sign_in_screen.dart';
import 'package:padel_club/screens/verificar_correo_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
  final llaveStripe = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  if (llaveStripe.isNotEmpty) {
    Stripe.publishableKey = llaveStripe;
    await Stripe.instance.applySettings();
  }
  await Notificaciones.init();
  final usuario = FirebaseAuth.instance.currentUser;
  final sesion = usuario != null &&
      (usuario.emailVerified || usuario.providerData.any((p) => p.providerId != 'password'));
  final prefs = await SharedPreferences.getInstance();
  final onboardingVisto = prefs.getBool('onboarding_visto') ?? false;
  runApp(MyApp(sesion: sesion, onboardingVisto: onboardingVisto));
}

class MyApp extends StatelessWidget {
  final bool sesion;
  final bool onboardingVisto;

  const MyApp({super.key, required this.sesion, required this.onboardingVisto});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
        ChangeNotifierProvider(create: (context) => PagoProvider()),
        ChangeNotifierProvider(create: (context) => ReservaProvider()),
        ChangeNotifierProvider(create: (context) => TopicsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: Notificaciones.navigatorKey,
            scaffoldMessengerKey: Notificaciones.scaffoldMessengerKey,
            scrollBehavior: const MaterialScrollBehavior().copyWith(overscroll: false),
            title: 'House of Padel',
            theme: ThemeApp.claroTheme(),
            darkTheme: ThemeApp.oscuroTheme(),
            themeMode: themeProvider.modo,
            initialRoute: !onboardingVisto ? '/onboarding' : sesion ? '/dash' : '/login',
            routes: {
              '/onboarding': (context) => OnboardingScreen(siguiente: sesion ? '/dash' : '/login'),
              '/login': (context) => const LoginScreen(),
              '/signIn': (context) => const SignInScreen(),
              '/verificar': (context) => const VerificarCorreoScreen(),
              '/recuperar': (context) => const RecuperarScreen(),
              '/dash': (context) => const DashboardScreen(),
              '/perfil': (context) => const PerfilScreen(),
              '/membresias': (context) => const MembresiasScreen(),
              '/pago': (context) => const PagoScreen(),
              '/pagoExitoso': (context) => const PagoExitosoScreen(),
              '/sede': (context) => const SedeScreen(),
              '/cancha': (context) => const CanchaDetalleScreen(),
              '/misReservas': (context) => const MisReservasScreen(),
              '/avisos': (context) => const AvisosScreen(),
              '/mapa': (context) => const MapScreen(),
            },
          );
        },
      ),
    );
  }
}
