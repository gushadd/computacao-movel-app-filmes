class Filme {
  int? id;
  String? titulo;
  String? diretor;
  int? anoLancamento;
  String? sinopse;
  int? generoId; // Chave estrangeira para o Gênero

  Filme({
    this.id,
    this.titulo,
    this.diretor,
    this.anoLancamento,
    this.sinopse,
    this.generoId,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'titulo': titulo,
      'diretor': diretor,
      'anoLancamento': anoLancamento,
      'sinopse': sinopse,
      'generoId': generoId,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      titulo: map['titulo'],
      diretor: map['diretor'],
      anoLancamento: map['anoLancamento'],
      sinopse: map['sinopse'],
      generoId: map['generoId'],
    );
  }
}
