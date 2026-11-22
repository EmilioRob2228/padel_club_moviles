import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:padel_club/components/theme_app.dart';
import 'package:padel_club/firebase_options.dart';
import 'package:padel_club/providers/login_provider.dart';
import 'package:padel_club/providers/pago_provider.dart';
import 'package:padel_club/providers/theme_provider.dart';
import 'package:padel_club/providers/usuario_provider.dart';
import 'package:padel_club/screens/dashboard_screen.dart';
import 'package:padel_club/screens/login_screen.dart';
import 'package:padel_club/screens/membresias_screen.dart';
import 'package:padel_club/screens/pago_exitoso_screen.dart';
import 'package:padel_club/screens/pago_screen.dart';
import 'package:padel_club/screens/perfil_screen.dart';
import 'package:padel_club/screens/recuperar_screen.dart';
import 'package:padel_club/screens/sign_in_screen.dart';
import 'package:padel_club/screens/verificar_correo_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
  final llaveStripe = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  if (llaveStripe.isNotEmpty) {
    Stripe.publishableKey = llaveStripe;
    await Stripe.instance.applySettings();
  }
  final usuario = FirebaseAuth.instance.currentUser;
  final sesion = usuario != null &&
      (usuario.emailVerified || usuario.providerData.any((p) => p.providerId != 'password'));
  runApp(MyApp(sesion: sesion));
}

class MyApp extends StatelessWidget {
  final bool sesion;

  const MyApp({super.key, required this.sesion});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
        ChangeNotifierProvider(create: (context) => PagoProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Club de Pádel',
            theme: ThemeApp.claroTheme(),
            darkTheme: ThemeApp.oscuroTheme(),
            themeMode: themeProvider.modo,
            initialRoute: sesion ? '/dash' : '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/signIn': (context) => const SignInScreen(),
              '/verificar': (context) => const VerificarCorreoScreen(),
              '/recuperar': (context) => const RecuperarScreen(),
              '/dash': (context) => const DashboardScreen(),
              '/perfil': (context) => const PerfilScreen(),
              '/membresias': (context) => const MembresiasScreen(),
              '/pago': (context) => const PagoScreen(),
              '/pagoExitoso': (context) => const PagoExitosoScreen(),
            },
          );
        },
      ),
    );
  }
}
