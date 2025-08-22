import 'package:firebase_auth/firebase_auth.dart';  // Importa a biblioteca do Firebase Authentication
import 'package:flutter/material.dart';  // Importa os widgets necessários para construir a interface com Material Design
import 'package:google_sign_in/google_sign_in.dart';  // Importa o pacote para autenticação com o Google
import 'package:horas_v3/screens/register_screen.dart';  // Importa a tela de registro do usuário
import 'package:horas_v3/screens/reset_password_modal.dart';  // Importa o modal para redefinição de senha

import '../services/auth_service.dart';  // Importa o serviço de autenticação personalizado

// Classe que representa a tela de Login do usuário
class LoginScreen extends StatelessWidget {
  final AuthService authService;  // Serviço de autenticação para gerenciar o login do usuário

  // Controladores para os campos de texto de email e senha
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Construtor da tela de login que recebe o AuthService
  LoginScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Scaffold é o widget base para uma tela, com estrutura visual e interações
      body: Container(
        color: Colors.blue,  // Cor de fundo da tela
        padding: const EdgeInsets.all(16),  // Adiciona espaçamento ao redor da tela
        child: Center(  // Centraliza o conteúdo na tela
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Alinha os widgets na coluna ao centro
            children: [
              Container(
                padding: const EdgeInsets.all(16),  // Espaçamento interno
                decoration: BoxDecoration(
                  color: Colors.white,  // Cor de fundo do contêiner
                  borderRadius: BorderRadius.circular(16),  // Bordas arredondadas
                ),
                child: Column(
                  children: [
                    const FlutterLogo(size: 76),  // Exibe o logo do Flutter
                    const SizedBox(height: 16),  // Espaçamento entre o logo e os campos de texto
                    // Campo de entrada de e-mail
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: 'E-mail'),  // Rótulo do campo
                    ),
                    const SizedBox(height: 16),  // Espaçamento entre os campos
                    // Campo de entrada de senha (texto oculto)
                    TextField(
                      obscureText: true,  // Torna o texto digitado invisível
                      controller: _senhaController,
                      decoration: const InputDecoration(hintText: 'Senha'),  // Rótulo do campo
                    ),
                    const SizedBox(height: 16),  // Espaçamento entre os campos
                    // Botão de "Entrar"
                    ElevatedButton(
                      onPressed: () {
                        // Chama o método de login quando o botão é pressionado
                        authService
                            .entrarUsuario(
                          email: _emailController.text,  // Pega o e-mail digitado
                          senha: _senhaController.text,  // Pega a senha digitada
                        )
                            .then((String? erro) {  // Aguarda o resultado do login
                          if (erro != null) {
                            // Se houver um erro, exibe uma mensagem de erro (SnackBar)
                            final snackBar = SnackBar(
                              content: Text(erro),  // Mensagem de erro
                              backgroundColor: Colors.red,  // Cor de fundo vermelha
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);  // Exibe o SnackBar
                          }
                        });
                      },
                      child: const Text('Entrar'),  // Texto do botão
                    ),
                    const SizedBox(height: 16),  // Espaçamento entre os botões
                    // Botão de "Entrar com Google"
                    ElevatedButton(
                      onPressed: () {
                        // Chama o método de login com o Google
                        signinWithGoogle();
                      },
                      child: const Text('Entrar com Google'),  // Texto do botão
                    ),
                    const SizedBox(height: 16),  // Espaçamento entre os botões
                    // Link para a tela de registro
                    TextButton(
                      onPressed: () {
                        // Navega para a tela de registro
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RegisterScreen(authService: authService),
                          ),
                        );
                      },
                      child: const Text('Ainda não tem uma conta? Crie uma conta'),  // Texto do link
                    ),
                    // Link para abrir o modal de redefinição de senha
                    TextButton(
                      onPressed: () {
                        // Exibe o modal para redefinir a senha
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PasswordresetModal();  // Exibe o modal de redefinição de senha
                          },
                        );
                      },
                      child: const Text('Esqueceu sua senha?'),  // Texto do link
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Função para login com o Google
  Future<UserCredential> signinWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();  // Inicia o processo de login com Google
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;  // Obtém a autenticação do Google
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,  // Obtém o accessToken do Google
      idToken: googleAuth.idToken,  // Obtém o idToken do Google
    );
    // Realiza o login no Firebase com as credenciais do Google
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
