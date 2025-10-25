import 'package:app_filmes/screens/add_filme_screen.dart';
import 'package:app_filmes/screens/add_genero_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../models/filme.dart';
import '../models/genero.dart';
import '../widgets/filme_list_item.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final List<Filme> _filmes = [
    Filme(id: 1, titulo: 'O Poderoso Chefão', diretor: 'Francis Ford Coppola', generoId: 1),
    Filme(id: 2, titulo: 'O Senhor dos Anéis: A Sociedade do Anel', diretor: 'Peter Jackson', generoId: 2),
    Filme(id: 3, titulo: 'Pulp Fiction', diretor: 'Quentin Tarantino', generoId: 1),
    Filme(id: 4, titulo: 'O Iluminado', diretor: 'Stanley Kubrick', generoId: 3),
    Filme(id: 5, titulo: 'Forrest Gump', diretor: 'Robert Zemeckis', generoId: 4),
  ];

  final List<Genero> _generos = [
    Genero(id: 1, nome: 'Crime', cor: Colors.red),
    Genero(id: 2, nome: 'Fantasia', cor: Colors.purple),
    Genero(id: 3, nome: 'Terror', cor: Colors.grey),
    Genero(id: 4, nome: 'Drama', cor: Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes'),
      ),
      body: ListView.builder(
        itemCount: _filmes.length,
        itemBuilder: (context, index) {
          final filme = _filmes[index];
          return FilmeListItem(filme: filme, generos: _generos);
        },
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.movie),
            label: 'Novo filme',
            onTap: () async {
              final novoFilme = await Navigator.of(context).push<Filme>(
                MaterialPageRoute(
                  builder: (context) => AddFilmeScreen(generos: _generos),
                ),
              );
              if (novoFilme != null) {
                setState(() {
                  _filmes.add(novoFilme);
                });
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.category),
            label: 'Novo gênero',
            onTap: () async {
              final novoGenero = await Navigator.of(context).push<Genero>(
                MaterialPageRoute(
                  builder: (context) => const AddGeneroScreen(),
                ),
              );
              if (novoGenero != null) {
                setState(() {
                  _generos.add(novoGenero);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}