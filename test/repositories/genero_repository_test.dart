import 'package:app_filmes/models/genero.dart';
import 'package:app_filmes/repositories/database_helper.dart';
import 'package:app_filmes/repositories/genero_repository.dart';
import 'package:flutter/material.dart';
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
        'nome': 'Teste',
        'descricao': 'descricao',
        'publicoAlvo': 'publico',
        'cor': 4294967295,
      },
    ]),
    returnValueForMissingStub: Future.value([
      {
        'id': 1,
        'nome': 'Teste',
        'descricao': 'descricao',
        'publicoAlvo': 'publico',
        'cor': 4294967295,
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
  late GeneroRepository generoRepository;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    generoRepository = GeneroRepository(databaseHelper: mockDatabaseHelper);
  });

  test('salvar um genero', () async {
    final genero = Genero(
      nome: 'Teste',
      descricao: 'descricao',
      publicoAlvo: 'publico',
      cor: Colors.blue,
    );

    when(mockDatabaseHelper.database).thenAnswer((_) async => MockDatabase());

    final result = await generoRepository.salvarGenero(genero);

    expect(result.id, 1);
  });

  test('listar generos', () async {
    when(mockDatabaseHelper.database).thenAnswer((_) async => MockDatabase());

    final result = await generoRepository.listarGeneros();

    expect(result.length, 1);
    expect(result[0].id, 1);
  });

  test('atualizar um genero', () async {
    final genero = Genero(
      id: 1,
      nome: 'Teste',
      descricao: 'descricao',
      publicoAlvo: 'publico',
      cor: Colors.blue,
    );

    when(mockDatabaseHelper.database).thenAnswer((_) async => MockDatabase());

    final result = await generoRepository.atualizarGenero(genero);

    expect(result, 1);
  });

  test('excluir um genero', () async {
    when(mockDatabaseHelper.database).thenAnswer((_) async => MockDatabase());

    final result = await generoRepository.excluirGenero(1);

    expect(result, 1);
  });
}
