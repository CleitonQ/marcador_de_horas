import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horas_v3/screens/register_screen.dart';
import 'package:horas_v3/screens/reset_password_modal.dart';
import 'package:horas_v3/l10n/app_localizations.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService authService;

  LoginScreen({super.key, required this.authService});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FlutterLogo(size: 76),
                  const SizedBox(height: 16),

                  // E-mail
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: l.emailLabel,
                      labelText: l.emailLabel,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Senha
                  TextField(
                    obscureText: true,
                    controller: _senhaController,
                    decoration: InputDecoration(
                      hintText: l.passwordLabel,
                      labelText: l.passwordLabel,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Entrar
                  ElevatedButton(
                    onPressed: () {
                      authService
                          .entrarUsuario(
                        email: _emailController.text,
                        senha: _senhaController.text,
                      )
                          .then((String? erro) {
                        if (erro != null) {
                          final snackBar = SnackBar(
                            content: Text(erro),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    child: Text(l.signInButton),
                  ),
                  const SizedBox(height: 16),

                  // Entrar com Google
                  ElevatedButton(
                    onPressed: () {
                      signinWithGoogle();
                    },
                    child: Text(l.signInWithGoogle),
                  ),
                  const SizedBox(height: 16),

                  // Criar conta
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegisterScreen(authService: authService),
                        ),
                      );
                    },
                    child: Text(l.noAccountCreate),
                  ),

                  // Esqueceu a senha
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => PasswordresetModal(),
                      );
                    },
                    child: Text(l.forgotPassword),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signinWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
