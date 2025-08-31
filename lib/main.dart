import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:horas_v3/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'models/theme_provider.dart';
import 'package:horas_v3/models/language_provider.dart';  // Importe o LanguageProvider
import 'package:horas_v3/l10n/app_localizations.dart'; // Para o uso das traduções
import 'package:flutter_localizations/flutter_localizations.dart';

// Função que simula uma operação cara (demorada)
int expensiveOperation(int input) {
  return input * 2;  // Retorna o dobro do valor (apenas exemplo)
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializando o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configuração de mensagens em segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),  // ThemeProvider
        ChangeNotifierProvider(create: (_) => LanguageProvider()),  // LanguageProvider
      ],
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final logger = Logger();
  logger.d('### Handling a background message ${message.messageId}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtendo o idioma atual do LanguageProvider
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Horas',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).currentTheme, // Usa o tema atual
      locale: languageProvider.locale, // Define o locale para o idioma atual
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // Inglês
        Locale('es', 'ES'), // Espanhol
        Locale('pt', 'BR'), // Português
      ],
      home: const RoteadorTelas(),
    );
  }
}

class RoteadorTelas extends StatelessWidget {
  const RoteadorTelas({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return FutureBuilder<int>(
      future: compute(expensiveOperation, 10), // Exemplo com input 10
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else {
          return StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  return HomeScreen(user: snapshot.data!);
                } else {
                  return LoginScreen(authService: authService);
                }
              }
            },
          );
        }
      },
    );
  }
}
