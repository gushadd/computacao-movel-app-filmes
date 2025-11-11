import 'package:app_filmes/repositories/filme_repository.dart';
import 'package:app_filmes/repositories/genero_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/filme.dart';
import '../models/genero.dart';

class AddFilmeScreen extends StatefulWidget {
  final FilmeRepository filmeRepository;
  final GeneroRepository generoRepository;
  final Filme? filme;

  const AddFilmeScreen({
    super.key,
    required this.filmeRepository,
    required this.generoRepository,
    this.filme,
  });

  @override
  State<AddFilmeScreen> createState() => _AddFilmeScreenState();
}

class _AddFilmeScreenState extends State<AddFilmeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _diretorController = TextEditingController();
  final _anoLancamentoController = TextEditingController();
  final _sinopseController = TextEditingController();
  Genero? _selectedGenero;
  late Future<List<Genero>> _generos;

  @override
  void initState() {
    super.initState();
    _generos = widget.generoRepository.listarGeneros();
    if (widget.filme != null) {
      _tituloController.text = widget.filme!.titulo ?? '';
      _diretorController.text = widget.filme!.diretor ?? '';
      _anoLancamentoController.text =
          widget.filme!.anoLancamento?.toString() ?? '';
      _sinopseController.text = widget.filme!.sinopse ?? '';
      _generos.then((generos) {
        setState(() {
          _selectedGenero = generos.firstWhere(
            (g) => g.id == widget.filme!.generoId,
          );
        });
      });
    } else {
      _generos.then((generos) {
        if (generos.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Nenhum gênero cadastrado'),
                content: const Text(
                  'Cadastre um gênero antes de adicionar um filme.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ).then((_) => Navigator.of(context).pop());
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filme == null ? 'Adicionar Filme' : 'Editar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: FutureBuilder<List<Genero>>(
            future: _generos,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final generos = snapshot.data!;
              return Column(
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o título';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _diretorController,
                    decoration: const InputDecoration(labelText: 'Diretor'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o diretor';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _anoLancamentoController,
                    decoration: const InputDecoration(
                      labelText: 'Ano de Lançamento',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o ano de lançamento';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _sinopseController,
                    decoration: const InputDecoration(labelText: 'Sinopse'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a sinopse';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<Genero>(
                    value: _selectedGenero,
                    items: generos.map((genero) {
                      return DropdownMenuItem<Genero>(
                        value: genero,
                        child: Text(genero.nome ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGenero = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Gênero'),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione o gênero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final novoFilme = Filme(
                          id: widget.filme?.id,
                          titulo: _tituloController.text,
                          diretor: _diretorController.text,
                          anoLancamento: int.parse(
                            _anoLancamentoController.text,
                          ),
                          sinopse: _sinopseController.text,
                          generoId: _selectedGenero!.id,
                        );
                        if (widget.filme == null) {
                          widget.filmeRepository.salvarFilme(novoFilme);
                        } else {
                          widget.filmeRepository.atualizarFilme(novoFilme);
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(widget.filme == null ? 'Salvar' : 'Atualizar'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
