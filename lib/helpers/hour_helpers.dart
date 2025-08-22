// Classe HourHelper com métodos utilitários para conversão entre horas e minutos
class HourHelper {
  // Método estático que converte uma string no formato 'HH:mm' para o equivalente em minutos
  static int hoursToMinutos(String hours) {
    // Divide a string 'hours' nas partes de hora e minuto usando o caractere ':'
    List<String> parts = hours.split(':');

    // Converte a parte da hora e dos minutos para inteiros
    int h = int.parse(parts[0]); // Converte a parte da hora para inteiro
    int m = int.parse(parts[1]); // Converte a parte dos minutos para inteiro

    // Retorna a soma da hora convertida para minutos (h * 60) mais os minutos
    return h * 60 + m;
  }

  // Método estático que converte um valor em minutos para o formato de hora 'HH:mm'
  static String minutesTohours(int minutes) {
    // Calcula a quantidade de horas inteiras
    int h = minutes ~/ 60; // Operação de divisão inteira (sem arredondamento)

    // Calcula os minutos restantes (menor que 60)
    int m = minutes % 60; // O operador '%' retorna o restante da divisão por 60 (minutos restantes)

    // Retorna a string formatada no formato 'HH:mm', com 2 dígitos para horas e minutos
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
