import 'package:flutter/material.dart';  // Importa o pacote Material Design do Flutter para criar interfaces
import 'package:horas_v3/services/auth_service.dart';  // Importa o serviço de autenticação personalizado

// Classe que representa o modal de recuperação de senha (StatefulWidget)
class PasswordresetModal extends StatefulWidget {
  const PasswordresetModal({super.key});  // Construtor da classe, permite a passagem de uma chave única para o widget

  @override
  State<PasswordresetModal> createState() => _PasswordresetModalState();  // Cria o estado para o widget
}

// O estado do modal, onde a lógica de exibição e ação é tratada
class _PasswordresetModalState extends State<PasswordresetModal> {
  final _formKey = GlobalKey<FormState>();  // Cria uma chave global para validar o formulário
  final _emailController = TextEditingController();  // Controlador para o campo de texto de e-mail

  AuthService authService = AuthService();  // Criação de uma instância do AuthService para gerenciar a autenticação

  @override
  Widget build(BuildContext context) {
    return AlertDialog(  // Cria um diálogo de alerta
      title: Text('Recuperar senha'),  // Título do modal
      content: Form(  // Formulário para coletar o e-mail do usuário
        key: _formKey,  // A chave para validar o formulário
        child: TextFormField(  // Campo de entrada de texto para o e-mail
          controller: _emailController,  // Controlador para o campo de e-mail
          keyboardType: TextInputType.emailAddress,  // Tipo de teclado específico para e-mails
          decoration: const InputDecoration(labelText: 'Endereço de e-mail'),  // Rótulo para o campo
          validator: (value) {  // Validador para garantir que o e-mail seja fornecido
            if (value!.isEmpty) {
              return 'Informe um endereço de e-mail válido';  // Retorna erro se o campo estiver vazio
            }
            return null;  // Retorna null se o e-mail for válido
          },
        ),
      ),
      actions: <TextButton>[  // Definindo as ações do modal (botões)
        TextButton(
          onPressed: () {  // Ação para fechar o modal
            Navigator.of(context).pop();  // Fecha o modal
          },
          child: Text('Cancelar'),  // Texto do botão de cancelar
        ),
        TextButton(
          onPressed: () {  // Ação para recuperar a senha
            if (_formKey.currentState!.validate()) {  // Valida o formulário antes de enviar a solicitação
              authService
                  .redefinicaoSenha(email: _emailController.text)  // Chama a função para redefinir a senha
                  .then((String? erro) {  // Aguarda o resultado da redefinição da senha
                Navigator.of(context).pop();  // Fecha o modal após a solicitação

                // Se ocorreu um erro durante a redefinição, exibe um snack bar com a mensagem de erro
                if (erro != null) {
                  final snackBar = SnackBar(
                      content: Text(erro), backgroundColor: Colors.red);  // Exibe mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);  // Exibe o snack bar
                } else {
                  // Se a redefinição foi bem-sucedida, exibe uma mensagem de sucesso
                  final snackBar = SnackBar(
                    content: Text(
                        'Um link de redefinição de senha foi enviado para o seu e-mail: ${_emailController.text}'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);  // Exibe o snack bar
                }
              });
            }
          },
          child: Text('Recuperar senha'),  // Texto do botão de recuperação de senha
        )
      ],
    );
  }
}
