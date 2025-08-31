import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
  <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  // Novos textos para as traduções no menu
  String get changeLanguageButton; // "Mudar Idioma"
  String get horas; // "Horas"
  String get deleteAccount; // "Excluir Conta"
  String get resetPassword; // "Redefinir Senha"
  String get changeTheme; // "Alterar Tema"
  String get logOut; // "Sair"
  String get confirmDeleteAccount; // "Confirmar exclusão"
  String get passwordPrompt; // "Digite sua senha para confirmar a exclusão da conta"
  String get cancel; // "Cancelar"
  String get confirm; // "Confirmar"
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Logic to select the correct localization class based on the language code
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
          'an issue with the localizations generation tool. Please file an issue '
          'on GitHub with a reproducible sample app and the gen-l10n configuration '
          'that was used.');
}

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

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
  String get passwordPrompt => 'Enter your password to confirm account deletion:';
  @override
  String get cancel => 'Cancel';
  @override
  String get confirm => 'Confirm';
}

class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt() : super('pt');

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
  String get passwordPrompt => 'Digite sua senha para confirmar a exclusão da conta:';
  @override
  String get cancel => 'Cancelar';
  @override
  String get confirm => 'Confirmar';
}
