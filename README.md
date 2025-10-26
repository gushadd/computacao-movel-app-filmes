# App Filmes

Este projeto é um aplicativo Flutter para gerenciar filmes e seus respectivos gêneros. Ele permite adicionar, visualizar, editar e excluir filmes e gêneros, utilizando um banco de dados SQLite para persistência de dados.

## Estrutura das Classes Modelo

O projeto possui duas classes modelo principais: `Filme` e `Genero`.

### `Filme`

Representa um filme com as seguintes propriedades:

*   `id`: `int?` - Identificador único do filme (gerado automaticamente pelo banco de dados).
*   `titulo`: `String?` - Título do filme.
*   `diretor`: `String?` - Diretor do filme.
*   `anoLancamento`: `int?` - Ano de lançamento do filme.
*   `sinopse`: `String?` - Sinopse do filme.
*   `paisOrigem`: `String?` - País de origem do filme.
*   `generoId`: `int?` - ID do gênero ao qual o filme pertence (chave estrangeira para a tabela `generos`).

### `Genero`

Representa um gênero de filme com as seguintes propriedades:

*   `id`: `int?` - Identificador único do gênero (gerado automaticamente pelo banco de dados).
*   `nome`: `String?` - Nome do gênero.
*   `descricao`: `String?` - Descrição do gênero.
*   `publicoAlvo`: `String?` - Público-alvo do gênero (ex: Infantil, Adulto).
*   `cor`: `Color?` - Cor associada ao gênero (utilizada na interface do usuário).

## Biblioteca e Lógica de Persistência

### Escolha da Biblioteca: `sqflite`

A biblioteca `sqflite` foi escolhida para a persistência de dados devido à sua popularidade, robustez e integração nativa com o Flutter para bancos de dados SQLite. O SQLite é uma excelente opção para aplicativos móveis que necessitam de um banco de dados local, pois é leve, rápido e não requer um servidor separado.

Para suportar o desenvolvimento em plataformas desktop (Windows, Linux, macOS), `sqflite_common_ffi` foi adicionado como dependência. Esta biblioteca permite que o `sqflite` funcione em ambientes que não são Android ou iOS, exigindo uma inicialização específica no `main.dart`.

### `DatabaseHelper`

A classe `DatabaseHelper` é responsável por gerenciar a criação e abertura do banco de dados. Ela implementa o padrão Singleton para garantir que apenas uma instância do banco de dados seja aberta durante a vida útil do aplicativo.

*   `_initDatabase()`: Este método inicializa o banco de dados, definindo o caminho do arquivo (`filmes.db`) e a versão. Ele também define a função `_onCreate` para criar as tabelas `generos` e `filmes` na primeira vez que o banco de dados é aberto.
*   `_onCreate()`: Define os esquemas das tabelas `generos` e `filmes`, incluindo chaves primárias, tipos de dados e uma chave estrangeira para relacionar filmes a gêneros.

## Fluxo de Dados nos Repositórios

Os repositórios (`FilmeRepository` e `GeneroRepository`) são responsáveis por abstrair a lógica de acesso aos dados, fornecendo métodos para operações CRUD (Create, Read, Update, Delete).

### Conversão de Objetos para o Banco de Dados (`toMap()`)

Para armazenar um objeto (`Filme` ou `Genero`) no banco de dados SQLite, ele precisa ser convertido em um `Map<String, dynamic>`. Cada classe modelo possui um método `toMap()` que realiza essa conversão, mapeando as propriedades do objeto para os nomes das colunas da tabela correspondente.

Exemplo (`Genero.toMap()`):

```dart
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'nome': nome,
    'descricao': descricao,
    'publicoAlvo': publicoAlvo,
    'cor': cor?.value, // Armazena o valor inteiro da cor
  };
}
```

### Conversão do Banco de Dados para Objetos (`fromMap()`)

Ao recuperar dados do banco de dados, eles vêm como um `Map<String, dynamic>`. Cada classe modelo possui um construtor `fromMap()` (ou um método estático `fromMap()`) que reconstrói o objeto a partir desse mapa.

Exemplo (`Genero.fromMap()`):

```dart
factory Genero.fromMap(Map<String, dynamic> map) {
  return Genero(
    id: map['id'],
    nome: map['nome'],
    descricao: map['descricao'],
    publicoAlvo: map['publicoAlvo'],
    cor: Color(map['cor']), // Converte o valor inteiro de volta para Color
  );
}
```

### `FilmeRepository`

*   `salvarFilme(Filme filme)`: Insere um novo filme no banco de dados.
*   `listarFilmes()`: Recupera todos os filmes do banco de dados.
*   `atualizarFilme(Filme filme)`: Atualiza um filme existente.
*   `excluirFilme(int id)`: Exclui um filme pelo seu ID.

### `GeneroRepository`

*   `salvarGenero(Genero genero)`: Insere um novo gênero no banco de dados.
*   `listarGeneros()`: Recupera todos os gêneros do banco de dados.
*   `atualizarGenero(Genero genero)`: Atualiza um gênero existente.
*   `excluirGenero(int id)`: Exclui um gênero pelo seu ID.

## Como Executar o Projeto

Siga os passos abaixo para configurar e executar o projeto em seu ambiente de desenvolvimento.

### Pré-requisitos

*   **Flutter SDK**: Certifique-se de ter o Flutter SDK instalado e configurado. Você pode verificar sua instalação executando `flutter doctor` no terminal.
*   **Android Studio / VS Code**: Um IDE com suporte a Flutter é recomendado.
*   **Emulador Android / Dispositivo Físico**: Para executar o aplicativo em Android.

### Passos para Execução

1.  **Clone o Repositório**:
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd app_filmes
    ```

2.  **Obtenha as Dependências**:
    ```bash
    flutter pub get
    ```

3.  **Configuração para Desktop (Opcional, se for rodar em Windows, Linux ou macOS)**:
    Se você planeja executar o aplicativo em desktop, certifique-se de que o `sqflite_common_ffi` esteja configurado corretamente. A inicialização já está presente no `main.dart`.

4.  **Resolva o NDK Version Mismatch (se ocorrer)**:
    Se você encontrar um erro de `ndkVersion` ao tentar rodar em um emulador Android, edite o arquivo `android/app/build.gradle.kts` e defina o `ndkVersion` para a versão mais recente sugerida pelo erro (ex: `"27.0.12077973"`).

    ```kotlin
    android {
        namespace = "com.example.app_filmes"
        compileSdk = flutter.compileSdkVersion
        ndkVersion = "27.0.12077973" // Atualize para a versão correta
        // ...
    }
    ```

5.  **Limpe o Projeto (se necessário)**:
    ```bash
    flutter clean
    ```

6.  **Execute o Aplicativo**:
    *   **Emulador Android / Dispositivo Físico**:
        Certifique-se de que seu emulador ou dispositivo esteja conectado e visível para o Flutter (use `flutter devices`).
        ```bash
        flutter run
        ```
        Ou para um dispositivo específico:
        ```bash
        flutter run -d <device_id>
        ```
    *   **Desktop (Windows, Linux, macOS)**:
        ```bash
        flutter run -d windows # ou linux, macos
        ```
    *   **Web**:
        ```bash
        flutter run -d chrome
        ```

Após a execução, o aplicativo será iniciado e você poderá começar a gerenciar seus filmes e gêneros.