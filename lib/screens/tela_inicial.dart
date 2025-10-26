import 'package:app_filmes/repositories/filme_repository.dart';
import 'package:app_filmes/repositories/genero_repository.dart';
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
  final FilmeRepository _filmeRepository = FilmeRepository();
  final GeneroRepository _generoRepository = GeneroRepository();
  List<Filme> _filmes = [];
  List<Genero> _generos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final filmes = await _filmeRepository.listarFilmes();
    final generos = await _generoRepository.listarGeneros();
    setState(() {
      _filmes = filmes;
      _generos = generos;
    });
  }

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
          return InkWell(
            onTap: () async {
              final filmeAtualizado = await Navigator.of(context).push<Filme>(
                MaterialPageRoute(
                  builder: (context) => AddFilmeScreen(generos: _generos, filme: filme),
                ),
              );
              if (filmeAtualizado != null) {
                await _filmeRepository.atualizarFilme(filmeAtualizado);
                _loadData();
              }
            },
            child: Dismissible(
              key: ValueKey(filme.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) async {
                await _filmeRepository.excluirFilme(filme.id!);
                final filmeRemovido = _filmes.removeAt(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${filme.titulo} removido'),
                    action: SnackBarAction(
                      label: 'Desfazer',
                      onPressed: () async {
                        await _filmeRepository.salvarFilme(filmeRemovido);
                        _loadData();
                      },
                    ),
                  ),
                );
                _loadData();
              },
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: FilmeListItem(filme: filme, generos: _generos),
            ),
          );
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
                await _filmeRepository.salvarFilme(novoFilme);
                _loadData();
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
                await _generoRepository.salvarGenero(novoGenero);
                _loadData();
              }
            },
          ),
        ],
      ),
    );
  }
}
