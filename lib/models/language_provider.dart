import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('pt', 'BR');  // Idioma inicial (Português - Brasil)

  Locale get locale => _locale;

  // Método para mudar o idioma
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();  // Notifica os ouvintes para atualizar o idioma
  }
}
