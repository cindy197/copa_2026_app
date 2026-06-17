class CopaData {
  CopaData._();

  static const Map<String, List<String>> gruposTimes = {
    'Grupo A': ['México', 'África do Sul', 'Coreia do Sul', 'Tchéquia'],
    'Grupo B': ['Canadá', 'Bósnia e Herzegovina', 'Catar', 'Suíça'],
    'Grupo C': ['Brasil', 'Marrocos', 'Haiti', 'Escócia'],
    'Grupo D': ['Estados Unidos', 'Paraguai', 'Austrália', 'Turquia'],
    'Grupo E': ['Alemanha', 'Curaçao', 'Costa do Marfim', 'Equador'],
    'Grupo F': ['Países Baixos', 'Japão', 'Suécia', 'Tunísia'],
    'Grupo G': ['Bélgica', 'Egito', 'Irã', 'Nova Zelândia'],
    'Grupo H': ['Espanha', 'Cabo Verde', 'Arábia Saudita', 'Uruguai'],
    'Grupo I': ['França', 'Senegal', 'Iraque', 'Noruega'],
    'Grupo J': ['Argentina', 'Argélia', 'Áustria', 'Jordânia'],
    'Grupo K': ['Portugal', 'RD Congo', 'Uzbequistão', 'Colômbia'],
    'Grupo L': ['Inglaterra', 'Croácia', 'Gana', 'Panamá'],
  };

  static const List<String> estadios = [
    'Estádio Azteca',
    'Estádio BBVA',
    'Estádio Akron',
    'BC Place',
    'BMO Field',
    'Estádio MetLife',
    'Estádio AT&T',
    'Estádio SoFi',
    'Estádio Arrowhead',
    "Estádio Levi's",
    'Estádio NRG',
    'Lincoln Financial Field',
    'Estádio Mercedes-Benz',
    'Lumen Field',
    'Estádio Hard Rock',
    'Estádio Gillette',
  ];

  static List<String> get grupos => gruposTimes.keys.toList();

  static List<String> get times => gruposTimes.values.expand((t) => t).toList();

  static List<String> timesDoGrupo(String? grupo) =>
      gruposTimes[grupo] ?? times;

  static String? grupoDoTime(String? time) {
    if (time == null) return null;
    for (final entry in gruposTimes.entries) {
      if (entry.value.contains(time)) return entry.key;
    }
    return null;
  }
}
