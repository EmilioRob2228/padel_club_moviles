import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:padel_club/components/theme_app.dart';
import 'package:padel_club/firebase_options.dart';
import 'package:padel_club/providers/theme_provider.dart';
import 'package:padel_club/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Club de Pádel',
            theme: ThemeApp.claroTheme(),
            darkTheme: ThemeApp.oscuroTheme(),
            themeMode: themeProvider.modo,
            home: const DashboardScreen(),
            routes: {
              '/dash': (context) => const DashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
