import 'package:app_filmes/models/genero.dart';
import 'package:app_filmes/repositories/genero_repository.dart';
import 'package:app_filmes/screens/add_genero_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_genero_form_test.mocks.dart';

@GenerateMocks([GeneroRepository])
void main() {
  late MockGeneroRepository mockGeneroRepository;

  setUp(() {
    mockGeneroRepository = MockGeneroRepository();
  });

  testWidgets('deve preencher o formulário de gênero e salvar', (
    WidgetTester tester,
  ) async {
    when(
      mockGeneroRepository.salvarGenero(any),
    ).thenAnswer((_) async => Genero());

    await tester.pumpWidget(
      MaterialApp(
        home: AddGeneroScreen(generoRepository: mockGeneroRepository),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Ação');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Filmes com muita adrenalina',
    );
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adulto').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salvar'));
    await tester.pump();

    verify(mockGeneroRepository.salvarGenero(any)).called(1);
  });
}
