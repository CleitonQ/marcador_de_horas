import 'package:flutter/material.dart';  // Importa o pacote para criar interfaces gráficas no Flutter
import 'package:horas_v3/services/auth_service.dart';  // Importa o serviço de autenticação personalizado

// Tela de Registro de Usuário
class RegisterScreen extends StatelessWidget {
  final AuthService authService;  // Serviço de autenticação que será passado para esta tela

  // Construtor que recebe uma instância de AuthService e a chave (key) para o widget
  RegisterScreen({Key? key, required this.authService}) : super(key: key);

  // Controladores de texto para os campos de entrada do formulário
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Scaffold fornece a estrutura básica da tela
      body: Container(
        color: Colors.blue,  // Cor de fundo da tela
        padding: const EdgeInsets.all(16),  // Adiciona um espaçamento ao redor do conteúdo
        child: Center(  // Centraliza o conteúdo na tela
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Alinha os elementos no centro da tela
            children: [
              Container(
                padding: const EdgeInsets.all(16),  // Espaçamento dentro do contêiner
                decoration: BoxDecoration(
                  color: Colors.white,  // Cor de fundo do formulário
                  borderRadius: BorderRadius.circular(16),  // Bordas arredondadas
                ),
                child: Column(
                  children: [
                    const FlutterLogo(size: 76),  // Exibe o logo do Flutter
                    const SizedBox(height: 16),  // Espaçamento entre o logo e o campo de texto
                    // Campo para o nome do usuário
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(hintText: 'Nome'),  // Rótulo do campo
                    ),
                    const SizedBox(height: 16),
                    // Campo para o e-mail do usuário
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: 'E-mail'),  // Rótulo do campo
                    ),
                    const SizedBox(height: 16),
                    // Campo para a senha (oculta o texto digitado)
                    TextField(
                      obscureText: true,  // Torna o texto digitado invisível
                      controller: _senhaController,
                      decoration: const InputDecoration(hintText: 'Senha'),  // Rótulo do campo
                    ),
                    const SizedBox(height: 16),
                    // Campo para confirmar a senha (também oculta o texto digitado)
                    TextField(
                      obscureText: true,  // Torna o texto digitado invisível
                      controller: _confirmaSenhaController,
                      decoration:
                      const InputDecoration(hintText: 'Confirme sua senha'),  // Rótulo do campo
                    ),
                    const SizedBox(height: 16),
                    // Botão para cadastrar o usuário
                    ElevatedButton(
                      onPressed: () {
                        // Verifica se as senhas inseridas são iguais
                        if (_senhaController.text == _confirmaSenhaController.text) {
                          // Chama o método de cadastro do serviço de autenticação
                          authService
                              .cadastrarUsuario(
                            email: _emailController.text,
                            Senha: _senhaController.text,
                            nome: _nomeController.text,
                          )
                              .then((String? erro) {
                            // Se ocorrer um erro, exibe uma mensagem de erro
                            if (erro != null) {
                              final snackBar = SnackBar(
                                content: Text(erro),  // Mensagem de erro
                                backgroundColor: Colors.red,  // Cor de fundo vermelha
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);  // Exibe o snack bar
                            } else {
                              // Se o cadastro for bem-sucedido, fecha a tela de cadastro
                              Navigator.pop(context);
                            }
                          });
                        } else {
                          // Se as senhas não forem iguais, exibe uma mensagem de erro
                          const snackBar = SnackBar(
                            content: Text('As senhas não correspondem'),  // Mensagem de erro
                            backgroundColor: Colors.red,  // Cor de fundo vermelha
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);  // Exibe o snack bar
                        }
                      },
                      child: const Text('Cadastrar'),  // Texto do botão
                    ),
                    const SizedBox(height: 16),  // Espaçamento após o botão
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
