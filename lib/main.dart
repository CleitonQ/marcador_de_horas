import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:horas_v3/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart'; // <-- Adicionando isso
import 'package:logger/logger.dart';  // <-- Importando o pacote de logger
import 'package:flutter/foundation.dart';  // <-- Importando para usar compute

// Função que simula uma operação cara (demorada)
int expensiveOperation(int input) {
  // Simulação de operação cara
  return input * 2;  // Retorna o dobro do valor (apenas exemplo)
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializando Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configuração de mensagens em segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Executando a operação cara em segundo plano (compute é uma operação assíncrona)
  // Aqui usamos FutureBuilder para aguardar a execução dessa operação e atualizar a UI
  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final logger = Logger(); // <-- Instanciando o logger
  logger.d('### Handling a background message ${message.messageId}');  // <-- Usando o logger
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // <-- Construtor agora é const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RoteadorTelas(),
    );
  }
}

class RoteadorTelas extends StatelessWidget {
  const RoteadorTelas({super.key}); // <-- Construtor agora é const

  @override
  Widget build(BuildContext context) {
    final authService = AuthService(); // <-- instanciando AuthService

    // Usando FutureBuilder para rodar a operação cara no segundo plano
    return FutureBuilder<int>(
      future: compute(expensiveOperation, 10),  // Exemplo com input 10
      builder: (context, snapshot) {
        // Verifica o estado da operação cara
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else {
          // Quando a operação cara terminar, mostramos o valor no log
          print("Resultado da operação cara: ${snapshot.data}");

          return StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  // Usuário autenticado, mostrando a tela inicial
                  return HomeScreen(user: snapshot.data!);
                } else {
                  // Usuário não autenticado, mostrando a tela de login
                  return LoginScreen(authService: authService); // <-- passando aqui
                }
              }
            },
          );
        }
      },
    );
  }
}
