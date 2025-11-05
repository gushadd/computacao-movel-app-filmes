import 'package:app_filmes/models/filme.dart';
import 'package:app_filmes/repositories/database_helper.dart';
import 'package:app_filmes/repositories/filme_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import '../test_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<Database> get database => super.noSuchMethod(
    Invocation.getter(#database),
    returnValue: Future.value(MockDatabase()),
    returnValueForMissingStub: Future.value(MockDatabase()),
  );
}

class MockDatabase extends Mock implements Database {
  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) => super.noSuchMethod(
    Invocation.method(
      #insert,
      [table, values],
      {#nullColumnHack: nullColumnHack, #conflictAlgorithm: conflictAlgorithm},
    ),
    returnValue: Future.value(1),
    returnValueForMissingStub: Future.value(1),
  );

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) => super.noSuchMethod(
    Invocation.method(
      #query,
      [table],
      {
        #distinct: distinct,
        #columns: columns,
        #where: where,
        #whereArgs: whereArgs,
        #groupBy: groupBy,
        #having: having,
        #orderBy: orderBy,
        #limit: limit,
        #offset: offset,
      },
    ),
    returnValue: Future.value([
      {
        'id': 1,
        'titulo': 'Teste',
        'diretor': 'diretor',
        'anoLancamento': 2022,
        'sinopse': 'sinopse',
        'generoId': 1,
      },
    ]),
    returnValueForMissingStub: Future.value([
      {
        'id': 1,
        'titulo': 'Teste',
        'diretor': 'diretor',
        'anoLancamento': 2022,
        'sinopse': 'sinopse',
        'generoId': 1,
      },
    ]),
  );

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) => super.noSuchMethod(
    Invocation.method(
      #update,
      [table, values],
      {
        #where: where,
        #whereArgs: whereArgs,
        #conflictAlgorithm: conflictAlgorithm,
      },
    ),
    returnValue: Future.value(1),
    returnValueForMissingStub: Future.value(1),
  );

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) =>
      super.noSuchMethod(
        Invocation.method(
          #delete,
          [table],
          {#where: where, #whereArgs: whereArgs},
        ),
        returnValue: Future.value(1),
        returnValueForMissingStub: Future.value(1),
      );
}

void main() {
  setupTestSqfliteFfi();
  late FilmeRepository filmeRepository;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    filmeRepository = FilmeRepository(databaseHelper: mockDatabaseHelper);
  });

  test('salvar um filme', () async {
    final filme = Filme(
      titulo: 'Teste',
      diretor: 'diretor',
      anoLancamento: 2022,
      sinopse: 'sinopse',
      generoId: 1,
    );

    when(mockDatabaseHelper.database).thenAnswer((_) async => MockDatabase());

    final result = await filmeRepository.salvarFilme(filme);

    expect(result.id, 1);
  });

  test('listar filmes', () async {
    when(mockDatabaseHelper.database).thenAnswer((_) async => MockDatabase());

    final result = await filmeRepository.listarFilmes();

    expect(result.length, 1);
    expect(result[0].id, 1);
  });

  test('atualizar um filme', () async {
    final filme = Filme(
      id: 1,
      titulo: 'Teste',
      diretor: 'diretor',
      anoLancamento: 2022,
      sinopse: 'sinopse',
      generoId: 1,
    );

    when(mockDatabaseHelper.database).thenAnswer((_) async => MockDatabase());

    final result = await filmeRepository.atualizarFilme(filme);

    expect(result, 1);
  });

  test('excluir um filme', () async {
    when(mockDatabaseHelper.database).thenAnswer((_) async => MockDatabase());

    final result = await filmeRepository.excluirFilme(1);

    expect(result, 1);
  });
}
