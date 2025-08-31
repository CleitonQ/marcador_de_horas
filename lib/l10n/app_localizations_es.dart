// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get changeLanguageButton => 'Cambiar Idioma';

  @override
  String get horas => 'Horas';

  @override
  String get deleteAccount => 'Eliminar Cuenta';

  @override
  String get resetPassword => 'Restablecer Contraseña';

  @override
  String get changeTheme => 'Cambiar Tema';

  @override
  String get logOut => 'Cerrar Sesión';

  @override
  String get confirmDeleteAccount => 'Confirmar Eliminación';

  @override
  String get passwordPrompt =>
      'Introduce tu contraseña para confirmar la eliminación de la cuenta:';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get confirmPasswordLabel => 'Confirma tu contraseña';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get signInButton => 'Iniciar sesión';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get noAccountCreate => '¿No tienes una cuenta? Crea una';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get total => 'Total';

  @override
  String get emptyStateMessage => 'Aún no hay registros';

  @override
  String get addButton => 'Añadir';

  @override
  String get addDialogTitle => 'Añadir registro';

  @override
  String get editDialogTitle => 'Editar registro';

  @override
  String get saveButton => 'Guardar';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get dateHint => '01/01/2025';

  @override
  String get timeLabel => 'Hora';

  @override
  String get workedHoursLabel => 'Horas trabajadas';

  @override
  String get workedHoursHint => '00:00';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get descriptionHint => 'Recordatorio de lo que hiciste';

  @override
  String get resetPasswordTitle => 'Recuperar contraseña';

  @override
  String get emailAddressLabel => 'Correo electrónico';

  @override
  String get enterValidEmail => 'Introduce un correo electrónico válido';

  @override
  String get recoverPasswordButton => 'Recuperar contraseña';

  @override
  String resetLinkSent(Object email) {
    return 'Se ha enviado un enlace de restablecimiento a tu correo: $email';
  }
}
