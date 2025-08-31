// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get changeLanguageButton => 'Mudar Idioma';

  @override
  String get horas => 'Horas';

  @override
  String get deleteAccount => 'Excluir Conta';

  @override
  String get resetPassword => 'Redefinir Senha';

  @override
  String get changeTheme => 'Alterar Tema';

  @override
  String get logOut => 'Sair';

  @override
  String get confirmDeleteAccount => 'Confirmar exclusão';

  @override
  String get passwordPrompt =>
      'Digite sua senha para confirmar a exclusão da conta:';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get nameLabel => 'Nome';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get confirmPasswordLabel => 'Confirme sua senha';

  @override
  String get registerButton => 'Cadastrar';

  @override
  String get passwordsDoNotMatch => 'As senhas não correspondem';

  @override
  String get signInButton => 'Entrar';

  @override
  String get signInWithGoogle => 'Entrar com Google';

  @override
  String get noAccountCreate => 'Ainda não tem uma conta? Crie uma conta';

  @override
  String get forgotPassword => 'Esqueceu sua senha?';

  @override
  String get total => 'Total';

  @override
  String get emptyStateMessage => 'Nenhum registro ainda';

  @override
  String get addButton => 'Adicionar';

  @override
  String get addDialogTitle => 'Adicionar registro';

  @override
  String get editDialogTitle => 'Editar registro';

  @override
  String get saveButton => 'Salvar';

  @override
  String get dateLabel => 'Data';

  @override
  String get dateHint => '01/01/2025';

  @override
  String get timeLabel => 'Hora';

  @override
  String get workedHoursLabel => 'Horas trabalhadas';

  @override
  String get workedHoursHint => '00:00';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get descriptionHint => 'Lembrete do que você fez';

  @override
  String get resetPasswordTitle => 'Recuperar senha';

  @override
  String get emailAddressLabel => 'Endereço de e-mail';

  @override
  String get enterValidEmail => 'Informe um endereço de e-mail válido';

  @override
  String get recoverPasswordButton => 'Recuperar senha';

  @override
  String resetLinkSent(Object email) {
    return 'Um link de redefinição de senha foi enviado para o seu e-mail: $email';
  }
}
