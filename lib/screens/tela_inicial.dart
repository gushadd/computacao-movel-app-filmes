import 'package:app_filmes/models/filme.dart';
import 'package:app_filmes/models/genero.dart';
import 'package:app_filmes/repositories/filme_repository.dart';
import 'package:app_filmes/repositories/genero_repository.dart';
import 'package:app_filmes/screens/add_filme_screen.dart';
import 'package:app_filmes/screens/add_genero_screen.dart';
import 'package:app_filmes/widgets/filme_list_item.dart';
import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  final FilmeRepository filmeRepository;
  final GeneroRepository generoRepository;

  TelaInicial({
    Key? key,
    FilmeRepository? filmeRepository,
    GeneroRepository? generoRepository,
  })  : filmeRepository = filmeRepository ?? FilmeRepository(),
        generoRepository = generoRepository ?? GeneroRepository(),
        super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Filme>> _filmes;
  late Future<List<Genero>> _generos;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _filmes = widget.filmeRepository.listarFilmes();
    _generos = widget.generoRepository.listarGeneros();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Filmes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.movie), text: 'Filmes'),
            Tab(icon: Icon(Icons.category), text: 'Gêneros'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFilmesTab(),
          _buildGenerosTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFilmesTab() {
    return FutureBuilder<List<dynamic>>(
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
              return Dismissible(
                key: ValueKey(filme.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await _showConfirmationDialog(
                    context,
                    'Confirmar Exclusão',
                    'Você tem certeza que deseja excluir o filme ${filme.titulo}?',
                  );
                },
                onDismissed: (direction) {
                  widget.filmeRepository.excluirFilme(filme.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${filme.titulo} removido')),
                  );
                  setState(() {
                    filmes.removeAt(index);
                  });
                },
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFilmeScreen(
                          filmeRepository: widget.filmeRepository,
                          generoRepository: widget.generoRepository,
                          filme: filme,
                        ),
                      ),
                    );
                    setState(() {
                      _filmes = widget.filmeRepository.listarFilmes();
                    });
                  },
                  child: FilmeListItem(filme: filme, generos: generos),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildGenerosTab() {
    return FutureBuilder<List<Genero>>(
      future: _generos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum gênero cadastrado.'));
        } else {
          final generos = snapshot.data!;
          return ListView.builder(
            itemCount: generos.length,
            itemBuilder: (context, index) {
              final genero = generos[index];
              return Dismissible(
                key: ValueKey(genero.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  final filmes = await widget.filmeRepository.listarFilmes();
                  final isAssociated =
                      filmes.any((filme) => filme.generoId == genero.id);
                  if (isAssociated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Não é possível excluir o gênero, pois ele está associado a um filme.'),
                      ),
                    );
                    return false;
                  }
                  return await _showConfirmationDialog(
                    context,
                    'Confirmar Exclusão',
                    'Você tem certeza que deseja excluir o gênero ${genero.nome}?',
                  );
                },
                onDismissed: (direction) {
                  widget.generoRepository.excluirGenero(genero.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${genero.nome} removido')),
                  );
                  setState(() {
                    generos.removeAt(index);
                  });
                },
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddGeneroScreen(
                          generoRepository: widget.generoRepository,
                          genero: genero,
                        ),
                      ),
                    );
                    setState(() {
                      _generos = widget.generoRepository.listarGeneros();
                    });
                  },
                  child: ListTile(
                    title: Text(genero.nome ?? 'Nome não informado'),
                    leading: CircleAvatar(
                      backgroundColor: genero.cor,
                      child: Text((genero.nome ?? 'S').substring(0, 1)),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_tabController.index == 0) {
      return FloatingActionButton(
        onPressed: () async {
          final generos = await _generos;
          if (generos.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cadastre um gênero antes de adicionar um filme.'),
              ),
            );
            return;
          }
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
        child: const Icon(Icons.add),
      );
    } else {
      return FloatingActionButton(
        onPressed: () async {
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
        child: const Icon(Icons.add),
      );
    }
  }
}