import 'package:flutter/material.dart';

class Genero {
  int? id;
  String? nome;
  String? descricao;
  String? publicoAlvo;
  Color? cor;

  Genero({this.id, this.nome, this.descricao, this.publicoAlvo, this.cor});

  Map<String, dynamic> toMap() {
    final map = {
      'nome': nome,
      'descricao': descricao,
      'publicoAlvo': publicoAlvo,
      'cor': cor?.value,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Genero.fromMap(Map<String, dynamic> map) {
    return Genero(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      publicoAlvo: map['publicoAlvo'],
      cor: map['cor'] != null ? Color(map['cor']) : null,
    );
  }
}
