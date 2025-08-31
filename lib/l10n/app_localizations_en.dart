// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get changeLanguageButton => 'Change Language';

  @override
  String get horas => 'Hours';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get changeTheme => 'Change Theme';

  @override
  String get logOut => 'Log Out';

  @override
  String get confirmDeleteAccount => 'Confirm Account Deletion';

  @override
  String get passwordPrompt =>
      'Enter your password to confirm account deletion:';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm your password';

  @override
  String get registerButton => 'Sign up';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get signInButton => 'Sign in';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get noAccountCreate => 'Don’t have an account? Create one';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get total => 'Total';

  @override
  String get emptyStateMessage => 'No records yet';

  @override
  String get addButton => 'Add';

  @override
  String get addDialogTitle => 'Add entry';

  @override
  String get editDialogTitle => 'Edit entry';

  @override
  String get saveButton => 'Save';

  @override
  String get dateLabel => 'Date';

  @override
  String get dateHint => '01/01/2025';

  @override
  String get timeLabel => 'Time';

  @override
  String get workedHoursLabel => 'Worked hours';

  @override
  String get workedHoursHint => '00:00';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Reminder of what you did';

  @override
  String get resetPasswordTitle => 'Recover password';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String get recoverPasswordButton => 'Recover password';

  @override
  String resetLinkSent(Object email) {
    return 'A password reset link has been sent to your email: $email';
  }
}
