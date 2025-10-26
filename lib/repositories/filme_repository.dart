import 'package:app_filmes/models/filme.dart';
import 'package:app_filmes/repositories/database_helper.dart';

class FilmeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Filme> salvarFilme(Filme filme) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert('filmes', filme.toMap());
      return Filme(
        id: id,
        titulo: filme.titulo,
        diretor: filme.diretor,
        anoLancamento: filme.anoLancamento,
        sinopse: filme.sinopse,
        paisOrigem: filme.paisOrigem,
        generoId: filme.generoId,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Filme>> listarFilmes() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('filmes');
    return List.generate(maps.length, (i) {
      return Filme.fromMap(maps[i]);
    });
  }

  Future<int> excluirFilme(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('filmes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> atualizarFilme(Filme filme) async {
    final db = await _databaseHelper.database;
    return await db.update('filmes', filme.toMap(), where: 'id = ?', whereArgs: [filme.id]);
  }
}
