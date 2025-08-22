import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Biblioteca para persistir dados simples

// A classe ThemeProvider gerencia o estado do tema e notifica os ouvintes quando houver alteração.
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Variável interna para armazenar o estado do tema (escuro ou claro)

  bool get isDarkMode => _isDarkMode; // Getter que retorna o estado atual do tema

  // Construtor que carrega o tema salvo nas preferências ao inicializar a classe
  ThemeProvider() {
    _loadTheme();
  }

  // Função que alterna entre os temas (escuro e claro)
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode; // Inverte o estado do tema
    _saveTheme(); // Salva a preferência atual
    notifyListeners(); // Notifica os ouvintes que o tema mudou
  }

  // Função que retorna o tema atual (ThemeData) com base no estado do tema
  ThemeData get currentTheme {
    return _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }

  // Função privada para carregar o tema salvo nas preferências do dispositivo
  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Obtém as preferências compartilhadas
    _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Obtém o valor salvo (ou false se não houver preferência)
    notifyListeners(); // Notifica os ouvintes que o estado do tema foi carregado
  }

  // Função privada para salvar a preferência do tema nas preferências compartilhadas
  _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Obtém as preferências compartilhadas
    prefs.setBool('isDarkMode', _isDarkMode); // Salva o estado atual do tema
  }
}
