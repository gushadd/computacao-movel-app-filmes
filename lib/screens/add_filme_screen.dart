import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/filme.dart';
import '../models/genero.dart';

class AddFilmeScreen extends StatefulWidget {
  final List<Genero> generos;

  const AddFilmeScreen({super.key, required this.generos});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
                decoration: const InputDecoration(labelText: 'Ano de Lançamento'),
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
                items: widget.generos.map((genero) {
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
                      id: DateTime.now().millisecondsSinceEpoch,
                      titulo: _tituloController.text,
                      diretor: _diretorController.text,
                      anoLancamento: int.parse(_anoLancamentoController.text),
                      sinopse: _sinopseController.text,
                      generoId: _selectedGenero!.id,
                    );
                    Navigator.of(context).pop(novoFilme);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}