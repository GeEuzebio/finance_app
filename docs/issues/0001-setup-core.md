# Issue #001 — Setup do core + DI + camada base

> ⚠️ Especificação original (Drift/`AppDatabase`), mantida como registro
> histórico. Depois do ADR 0005, `AppDatabase`/DAOs foram removidos; o DI
> registra um `SupabaseClient` (`Supabase.instance.client`) em vez disso —
> ver `lib/core/di/injection.dart` e `lib/main.dart` para o estado atual.

## Objetivo
Deixar o projeto Flutter compilando com a espinha dorsal de infraestrutura
funcionando — DI resolvendo, conexão com o banco abrindo e fechando — sem
nenhuma tabela de feature, repositório ou caso de uso ainda. Esta issue é
puramente infraestrutura; a próxima (#002) adiciona as 7 tabelas de domínio.

## Fora de escopo (explicitamente)
- Nenhuma tabela de feature em `AppDatabase` (fica vazio, só o esqueleto).
- Nenhuma entidade de domínio, repositório, caso de uso ou widget.
- Nenhuma tela além do `runApp` mínimo em `main.dart`.

## Lista exata de arquivos a criar

```
pubspec.yaml                                    # conteúdo já definido nesta sessão
analysis_options.yaml                            # flutter_lints
lib/
  main.dart
  core/
    di/
      injection.dart
      injection.config.dart                      # gerado por build_runner, não escrito à mão
    errors/
      failure.dart
    database/
      app_database.dart
      app_database.g.dart                         # gerado por build_runner, não escrito à mão
      connection.dart
test/
  core/
    di/
      injection_test.dart
    database/
      app_database_test.dart
```

### `lib/core/errors/failure.dart`
Implementa a hierarquia completa já especificada em
`docs/ARCHITECTURE.md` §6 (`Failure`, `ValidationFailure`, `NotFoundFailure`,
`DatabaseFailure`, `ProjectionFailure`) — não é um placeholder, é a
implementação final; issues futuras só adicionam subtipos se necessário.

### `lib/core/database/app_database.dart`
```dart
@DriftDatabase(tables: []) // tabelas entram na Issue #002
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.connection);

  @override
  int get schemaVersion => 1;
}
```
Esqueleto proposital sem tabelas — só prova que a conexão Drift abre.

### `lib/core/database/connection.dart`
Abre `NativeDatabase` apontando para um arquivo em
`getApplicationDocumentsDirectory()` (via `path_provider` + `path`) em
produção, e expõe uma função separada para abrir `NativeDatabase.memory()`
usada pelos testes.

### `lib/core/di/injection.dart`
```dart
final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
```
Como não há nenhuma classe anotada `@Injectable`/`@LazySingleton` ainda
(infraestrutura registrada manualmente nesta issue: `AppDatabase` via
`@module`), `injection.config.dart` gerado fica praticamente vazio — é
esperado, prova só que o pipeline de codegen do `injectable` funciona
ponta a ponta.

### `lib/main.dart`
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const _BootstrapApp());
}
```
`_BootstrapApp` é um `MaterialApp` com uma única tela placeholder de texto
("Finance App — setup OK") — não conta como feature, é só prova de que o
bootstrap não quebra.

## Estratégia de teste

Sem lógica de negócio nesta issue, então os testes são só de infraestrutura:

- **`test/core/database/app_database_test.dart`**: abre `AppDatabase` com
  `NativeDatabase.memory()`, verifica que `db.schemaVersion == 1` e que
  `db.close()` não lança erro.
- **`test/core/di/injection_test.dart`**: chama `configureDependencies()`
  contra uma instância limpa de `GetIt` (`getIt.reset()` no `setUp`) e
  verifica que `getIt<AppDatabase>()` resolve sem lançar
  (`ObjectFactoryUnregisteredError`).

Nenhum outro teste é necessário nesta issue — cobertura de regra de negócio
começa em M1 (#004–#006), quando existe regra de negócio para cobrir.

## Critérios de aceite
- `flutter analyze` limpo (regras do `flutter_lints`).
- `dart run build_runner build --delete-conflicting-outputs` gera
  `app_database.g.dart` e `injection.config.dart` sem erro.
- `flutter test` verde (os 2 testes acima).
- `flutter run` sobe o app e mostra a tela placeholder sem crash.

## Dependências
Nenhuma — é a primeira issue do projeto.
