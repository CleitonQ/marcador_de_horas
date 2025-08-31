import 'package:flutter/material.dart';
import 'package:horas_v3/services/auth_service.dart';
import 'package:horas_v3/l10n/app_localizations.dart';

class PasswordresetModal extends StatefulWidget {
  const PasswordresetModal({super.key});

  @override
  State<PasswordresetModal> createState() => _PasswordresetModalState();
}

class _PasswordresetModalState extends State<PasswordresetModal> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l.resetPasswordTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: l.emailAddressLabel),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l.enterValidEmail;
            }
            return null;
          },
        ),
      ),
      actions: <TextButton>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              authService
                  .redefinicaoSenha(email: _emailController.text.trim())
                  .then((String? erro) {
                Navigator.of(context).pop();

                if (erro != null) {
                  final snackBar = SnackBar(
                    content: Text(erro),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  final snackBar = SnackBar(
                    content: Text(
                      l.resetLinkSent(_emailController.text.trim()),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              });
            }
          },
          child: Text(l.recoverPasswordButton),
        )
      ],
    );
  }
}
