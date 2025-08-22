import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa o Firebase Auth para manipulação de autenticação
import 'package:horas_v3/services/auth_service.dart'; // Serviço personalizado de autenticação (como login e logout)
import 'package:horas_v3/screens/reset_password_modal.dart'; // Modal para redefinir a senha
import 'package:provider/provider.dart';  // Importa o provider para gerenciar o estado (ex: tema)
import 'package:horas_v3/models/theme_provider.dart'; // Importa o ThemeProvider, responsável pela alternância de tema

// Menu é um widget que representa o menu lateral (Drawer) do app
class Menu extends StatelessWidget {
  final User user; // O usuário logado, passado como parâmetro para o Menu

  // Construtor da classe Menu que recebe o usuário logado
  const Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Controlador para a senha que será digitada ao confirmar a exclusão de conta
    TextEditingController _senhaController = TextEditingController();

    return Drawer( // Define o menu lateral
      child: ListView(
        children: [
          // Cabeçalho do menu com informações do usuário
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.manage_accounts_rounded,
                size: 48, // Tamanho do ícone do avatar
              ),
            ),
            // Nome do usuário
            accountName: Text((user.displayName != null) ? user.displayName! : ''),
            // Email do usuário
            accountEmail: Text(user.email!),
          ),
          // Botão para excluir conta
          ListTile(
            leading: Icon(Icons.delete), // Ícone de lixeira
            title: const Text('Excluir Conta'),
            onTap: () async {
              // Exibe um diálogo para confirmar a exclusão da conta
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar exclusão'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Digite sua senha para confirmar a exclusão da conta:'),
                      TextField(
                        controller: _senhaController, // Controlador do campo de senha
                        obscureText: true, // Oculta a senha digitada
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
                        String senha = _senhaController.text; // Obtém a senha digitada
                        // Chama o método de exclusão de conta passando a senha
                        String? resposta = await AuthService().excluirConta(senha: senha);
                        Navigator.of(context).pop(); // Fecha o diálogo

                        // Exibe a resposta do servidor (sucesso ou erro)
                        if (resposta != null) {
                          final snackBar = SnackBar(
                            content: Text(resposta),
                            backgroundColor: Colors.red, // Cor de fundo para erro
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final snackBar = SnackBar(
                            content: Text('Conta excluída com sucesso!'),
                            backgroundColor: Colors.green, // Cor de fundo para sucesso
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
            leading: Icon(Icons.lock_reset), // Ícone de redefinir senha
            title: const Text('Redefinir Senha'),
            onTap: () {
              // Exibe o modal para redefinir a senha
              showDialog(
                context: context,
                builder: (context) => const PasswordresetModal(),
              );
            },
          ),
          // Botão para alterar o tema do app (modo claro ou escuro)
          ListTile(
            leading: Icon(Icons.brightness_4), // Ícone de troca de tema
            title: const Text('Alterar Tema'),
            onTap: () {
              // Alterna o tema entre claro e escuro
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          // Botão para deslogar
          ListTile(
            leading: Icon(Icons.logout), // Ícone de sair
            title: const Text('Sair'),
            onTap: () {
              // Chama o método para deslogar o usuário
              AuthService().deslogar();
            },
          ),
        ],
      ),
    );
  }
}
