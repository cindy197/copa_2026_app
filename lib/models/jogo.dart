class Jogo {
  int? id;
  String? timeA;
  String? timeB;
  int? golsA;
  int? golsB;
  String? data;
  String? estadio;
  String? grupo;
  String status;

  Jogo({
    this.id,
    required this.timeA,
    required this.timeB,
    this.golsA = 0,
    this.golsB = 0,
    this.data,
    this.estadio,
    this.grupo,
    this.status = 'agendado',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timeA': timeA,
      'timeB': timeB,
      'golsA': golsA,
      'golsB': golsB,
      'data': data,
      'estadio': estadio,
      'grupo': grupo,
      'status': status,
    };
    
  }

  factory Jogo.fromMap(Map<String, dynamic> map) {
    return Jogo(
      id: map['id'] as int?,
      timeA: map['timeA'] as String?,
      timeB: map['timeB'] as String?,
      golsA: (map['golsA'] as int?) ?? 0,
      golsB: (map['golsB'] as int?) ?? 0,
      data: map['data'] as String?,
      estadio: map['estadio'] as String?,
      grupo: map['grupo'] as String?,
      status: (map['status'] as String?) ?? 'agendado',
    );
  }

}