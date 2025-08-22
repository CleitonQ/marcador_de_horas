// Definindo a classe Hour que representa um registro de hora trabalhada.
class Hour {
  String id; // Identificador único do registro de hora (geralmente um UUID).
  String data; // Data em formato de string (por exemplo, "01/01/2025").
  int minutos; // Quantidade de minutos trabalhados.
  String? descricao; // Descrição opcional do que foi feito nesse período de trabalho.

  // Construtor que recebe os valores necessários para criar um objeto Hour
  Hour({
    required this.id, // O ID é obrigatório
    required this.data, // A data é obrigatória
    required this.minutos, // Os minutos são obrigatórios
    this.descricao, // A descrição é opcional
  });

  // Construtor nomeado 'fromMap' que cria uma instância de Hour a partir de um mapa de dados
  Hour.fromMap(Map<String, dynamic> map)
      : id = map['id'], // Atribui o valor de 'id' do mapa ao atributo 'id' da classe
        data = map['data'], // Atribui o valor de 'data' do mapa ao atributo 'data' da classe
        minutos = map['minutos'], // Atribui o valor de 'minutos' do mapa ao atributo 'minutos' da classe
        descricao = map['descricao']; // Atribui o valor de 'descricao' do mapa ao atributo 'descricao' da classe (se existir)

  // Função que converte a instância de Hour em um mapa (para salvar em Firestore, por exemplo)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Mapeia o valor do atributo 'id' para a chave 'id'
      'data': data, // Mapeia o valor do atributo 'data' para a chave 'data'
      'minutos': minutos, // Mapeia o valor do atributo 'minutos' para a chave 'minutos'
      'descricao': descricao, // Mapeia o valor do atributo 'descricao' para a chave 'descricao'
    };
  }
}
