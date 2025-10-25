import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/genero.dart';

class AddGeneroScreen extends StatefulWidget {
  const AddGeneroScreen({super.key});

  @override
  State<AddGeneroScreen> createState() => _AddGeneroScreenState();
}

class _AddGeneroScreenState extends State<AddGeneroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  String? _selectedPublicoAlvo;
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Gênero'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedPublicoAlvo,
                items: ['Infantil', 'Adolescente', 'Adulto', 'Todos os públicos']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPublicoAlvo = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Público Alvo'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione o público alvo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Cor:'),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Selecione uma cor'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: _selectedColor,
                              onColorChanged: (color) {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Salvar'),
                            )
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final novoGenero = Genero(
                      id: DateTime.now().millisecondsSinceEpoch,
                      nome: _nomeController.text,
                      descricao: _descricaoController.text,
                      publicoAlvo: _selectedPublicoAlvo,
                      cor: _selectedColor,
                    );
                    Navigator.of(context).pop(novoGenero);
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
