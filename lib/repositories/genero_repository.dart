import 'package:app_filmes/models/genero.dart';
import 'package:app_filmes/repositories/database_helper.dart';

class GeneroRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Genero> salvarGenero(Genero genero) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert('generos', genero.toMap());
      return Genero(
        id: id,
        nome: genero.nome,
        descricao: genero.descricao,
        publicoAlvo: genero.publicoAlvo,
        cor: genero.cor,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Genero>> listarGeneros() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('generos');
    return List.generate(maps.length, (i) {
      return Genero.fromMap(maps[i]);
    });
  }

  Future<int> excluirGenero(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('generos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> atualizarGenero(Genero genero) async {
    final db = await _databaseHelper.database;
    return await db.update('generos', genero.toMap(), where: 'id = ?', whereArgs: [genero.id]);
  }
}
