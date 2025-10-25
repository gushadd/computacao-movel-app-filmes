import 'package:flutter/material.dart';
import '../models/filme.dart';
import '../models/genero.dart';

class FilmeListItem extends StatelessWidget {
  const FilmeListItem({super.key, required this.filme, required this.generos});

  final Filme filme;
  final List<Genero> generos;

  @override
  Widget build(BuildContext context) {
    final genero = generos.firstWhere(
      (g) => g.id == filme.generoId,
      orElse: () => Genero(nome: 'Desconhecido', cor: Colors.grey),
    );
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(filme.titulo ?? ''),
        subtitle: Row(
          children: [
            Chip(
              label: Text(genero.nome ?? 'Desconhecido'),
              backgroundColor: genero.cor,
            ),
            const SizedBox(width: 8),
            Text(filme.diretor ?? ''),
          ],
        ),
      ),
    );
  }
}
