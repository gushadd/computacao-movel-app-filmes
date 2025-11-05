import 'package:app_filmes/models/filme.dart';
import 'package:app_filmes/models/genero.dart';
import 'package:app_filmes/repositories/filme_repository.dart';
import 'package:app_filmes/repositories/genero_repository.dart';
import 'package:app_filmes/screens/add_filme_screen.dart';
import 'package:app_filmes/screens/add_genero_screen.dart';
import 'package:app_filmes/widgets/filme_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TelaInicial extends StatefulWidget {
  final FilmeRepository filmeRepository;
  final GeneroRepository generoRepository;

  TelaInicial({
    Key? key,
    FilmeRepository? filmeRepository,
    GeneroRepository? generoRepository,
  }) : filmeRepository = filmeRepository ?? FilmeRepository(),
       generoRepository = generoRepository ?? GeneroRepository(),
       super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late Future<List<Filme>> _filmes;
  late Future<List<Genero>> _generos;

  @override
  void initState() {
    super.initState();
    _filmes = widget.filmeRepository.listarFilmes();
    _generos = widget.generoRepository.listarGeneros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Filmes')),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_filmes, _generos]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              (snapshot.data![0] as List<Filme>).isEmpty) {
            return const Center(child: Text('Nenhum filme cadastrado.'));
          } else {
            final filmes = snapshot.data![0] as List<Filme>;
            final generos = snapshot.data![1] as List<Genero>;
            return ListView.builder(
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                final genero = generos.firstWhere(
                  (g) => g.id == filme.generoId,
                  orElse: () => Genero(nome: 'Desconhecido', cor: Colors.grey),
                );
                return FilmeListItem(filme: filme, generos: generos);
              },
            );
          }
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.movie),
            label: 'Adicionar Filme',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFilmeScreen(
                    filmeRepository: widget.filmeRepository,
                    generoRepository: widget.generoRepository,
                  ),
                ),
              );
              setState(() {
                _filmes = widget.filmeRepository.listarFilmes();
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.category),
            label: 'Adicionar Gênero',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddGeneroScreen(
                    generoRepository: widget.generoRepository,
                  ),
                ),
              );
              setState(() {
                _generos = widget.generoRepository.listarGeneros();
              });
            },
          ),
        ],
      ),
    );
  }
}
