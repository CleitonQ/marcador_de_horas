import 'package:firebase_auth/firebase_auth.dart'; // se precisar do tipo User em algum lugar
import 'package:flutter/material.dart';
import 'package:horas_v3/services/auth_service.dart';
import 'package:horas_v3/l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  final AuthService authService;

  RegisterScreen({Key? key, required this.authService}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

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

                  // Nome
                  TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(hintText: l.nameLabel),
                  ),
                  const SizedBox(height: 16),

                  // E-mail
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: l.emailLabel),
                  ),
                  const SizedBox(height: 16),

                  // Senha
                  TextField(
                    obscureText: true,
                    controller: _senhaController,
                    decoration: InputDecoration(hintText: l.passwordLabel),
                  ),
                  const SizedBox(height: 16),

                  // Confirmar senha
                  TextField(
                    obscureText: true,
                    controller: _confirmaSenhaController,
                    decoration: InputDecoration(hintText: l.confirmPasswordLabel),
                  ),
                  const SizedBox(height: 20),

                  // BOTÕES CENTRALIZADOS
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_senhaController.text == _confirmaSenhaController.text) {
                            authService
                                .cadastrarUsuario(
                              email: _emailController.text,
                              Senha: _senhaController.text,
                              nome: _nomeController.text,
                            )
                                .then((String? erro) {
                              if (erro != null) {
                                final snackBar = SnackBar(
                                  content: Text(erro),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                Navigator.pop(context);
                              }
                            });
                          } else {
                            final snackBar = SnackBar(
                              content: Text(l.passwordsDoNotMatch),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Text(l.registerButton),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
