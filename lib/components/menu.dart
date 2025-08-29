import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:horas_v3/services/auth_service.dart';
import 'package:horas_v3/screens/reset_password_modal.dart';
import 'package:horas_v3/models/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:horas_v3/models/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  final User user; // O usuário logado, passado como parâmetro para o Menu

  const Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Controlador para a senha que será digitada ao confirmar a exclusão de conta
    TextEditingController _senhaController = TextEditingController();

    // Obtendo o LanguageProvider corretamente
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        children: [
          // Cabeçalho do menu com informações do usuário
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.manage_accounts_rounded,
                size: 48,
              ),
            ),
            accountName: Text((user.displayName != null) ? user.displayName! : ''),
            accountEmail: Text(user.email!),
          ),
          // Botão para excluir conta
          ListTile(
            leading: Icon(Icons.delete),
            title: const Text('Excluir Conta'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar exclusão'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Digite sua senha para confirmar a exclusão da conta:'),
                      TextField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                        ),
                      ),
                    ],
                  ),
                  actions: <TextButton>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        String senha = _senhaController.text;
                        String? resposta = await AuthService().excluirConta(senha: senha);
                        Navigator.of(context).pop();

                        if (resposta != null) {
                          final snackBar = SnackBar(
                            content: Text(resposta),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final snackBar = SnackBar(
                            content: Text('Conta excluída com sucesso!'),
                            backgroundColor: Colors.green,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text('Excluir Conta'),
                    ),
                  ],
                ),
              );
            },
          ),
          // Botão para redefinir senha
          ListTile(
            leading: Icon(Icons.lock_reset),
            title: const Text('Redefinir Senha'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const PasswordresetModal(),
              );
            },
          ),
          // Botão para alterar tema
          ListTile(
            leading: Icon(Icons.brightness_4),
            title: const Text('Alterar Tema'),
            onTap: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          // Botão para alterar idioma
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Idioma'),
            onTap: () {
              // Exibir diálogo com opções de idioma
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text('Escolha o idioma'),
                  children: [
                    SimpleDialogOption(
                      onPressed: () async {
                        languageProvider.setLocale(Locale('en', 'US')); // Mudar para inglês
                        // Salvar idioma em SharedPreferences
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('language', 'en');
                        Navigator.of(context).pop(); // Fecha o diálogo
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Text('English'),
                        ],
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        languageProvider.setLocale(Locale('pt', 'BR')); // Mudar para português
                        // Salvar idioma em SharedPreferences
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('language', 'pt');
                        Navigator.of(context).pop(); // Fecha o diálogo
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Text('Português'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Botão para deslogar
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              AuthService().deslogar();
            },
          ),
        ],
      ),
    );
  }
}
