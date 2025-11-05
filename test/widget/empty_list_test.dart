import 'package:app_filmes/models/filme.dart';
import 'package:app_filmes/models/genero.dart';
import 'package:app_filmes/repositories/filme_repository.dart';
import 'package:app_filmes/repositories/genero_repository.dart';
import 'package:app_filmes/screens/tela_inicial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFilmeRepository extends Mock implements FilmeRepository {
  @override
  Future<List<Filme>> listarFilmes() => super.noSuchMethod(
    Invocation.method(#listarFilmes, []),
    returnValue: Future.value(<Filme>[]),
  );
}

class MockGeneroRepository extends Mock implements GeneroRepository {
  @override
  Future<List<Genero>> listarGeneros() => super.noSuchMethod(
    Invocation.method(#listarGeneros, []),
    returnValue: Future.value(<Genero>[]),
  );
}

void main() {
  late MockFilmeRepository mockFilmeRepository;
  late MockGeneroRepository mockGeneroRepository;

  setUp(() {
    mockFilmeRepository = MockFilmeRepository();
    mockGeneroRepository = MockGeneroRepository();
  });

  testWidgets(
    'deve exibir uma mensagem quando a lista de filmes estiver vazia',
    (WidgetTester tester) async {
      when(
        mockFilmeRepository.listarFilmes(),
      ).thenAnswer((_) => Future.value(<Filme>[]));
      when(
        mockGeneroRepository.listarGeneros(),
      ).thenAnswer((_) => Future.value(<Genero>[]));

      await tester.pumpWidget(
        MaterialApp(
          home: TelaInicial(
            filmeRepository: mockFilmeRepository,
            generoRepository: mockGeneroRepository,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Nenhum filme cadastrado.'), findsOneWidget);
    },
  );
}
