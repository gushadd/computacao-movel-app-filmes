class Filme {
  int? id;
  String? titulo;
  String? diretor;
  int? anoLancamento;
  String? sinopse;
  String? paisOrigem;
  int? generoId; // Chave estrangeira para o Gênero

  Filme({
    this.id,
    this.titulo,
    this.diretor,
    this.anoLancamento,
    this.sinopse,
    this.paisOrigem,
    this.generoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'diretor': diretor,
      'anoLancamento': anoLancamento,
      'sinopse': sinopse,
      'paisOrigem': paisOrigem,
      'generoId': generoId,
    };
  }

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      titulo: map['titulo'],
      diretor: map['diretor'],
      anoLancamento: map['anoLancamento'],
      sinopse: map['sinopse'],
      paisOrigem: map['paisOrigem'],
      generoId: map['generoId'],
    );
  }
}
