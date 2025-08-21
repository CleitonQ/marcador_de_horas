import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:horas_v3/services/auth_service.dart';
import 'package:horas_v3/screens/reset_password_modal.dart'; // Importando o modal

class Menu extends StatelessWidget {
  final User user;
  const Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Criando o controlador de texto para capturar a senha digitada
    TextEditingController _senhaController = TextEditingController();

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.manage_accounts_rounded,
                size: 48,
              ),
            ),
            accountName: Text(
              (user.displayName != null) ? user.displayName! : '',
            ),
            accountEmail: Text(user.email!),
          ),
          // Botão para Excluir Conta
          ListTile(
            leading: Icon(Icons.delete),
            title: const Text('Excluir Conta'),
            onTap: () async {
              // Exibe um diálogo para o usuário confirmar a exclusão com a senha
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar exclusão'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Digite sua senha para confirmar a exclusão da conta:'),
                      TextField(
                        controller: _senhaController,  // Controlador para capturar a senha digitada
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
                        Navigator.of(context).pop(); // Fecha o diálogo
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Captura a senha digitada e chama o método excluirConta
                        String senha = _senhaController.text;
                        String? resposta = await AuthService().excluirConta(senha: senha);
                        Navigator.of(context).pop(); // Fecha o diálogo

                        if (resposta != null) {
                          // Exibe mensagem de erro
                          final snackBar = SnackBar(
                            content: Text(resposta),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          // Conta excluída com sucesso
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
          // Botão para Redefinir Senha
          ListTile(
            leading: Icon(Icons.lock_reset),
            title: const Text('Redefinir Senha'),
            onTap: () {
              // Exibe o modal de redefinir senha ao pressionar o botão
              showDialog(
                context: context,
                builder: (context) => const PasswordresetModal(), // Chama o modal
              );
            },
          ),
          // Botão para Sair
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
