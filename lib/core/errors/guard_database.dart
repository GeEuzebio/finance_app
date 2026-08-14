import 'package:fpdart/fpdart.dart';

import 'failure.dart';

/// Executa [run] e mapeia o resultado para `Either<Failure, T>`: sucesso
/// vira `Right`, qualquer `Failure` lançada dentro de [run] (ex.:
/// `NotFoundFailure`) é repassada como `Left`, e qualquer outra exceção
/// (driver Drift/sqlite) vira `Left(DatabaseFailure(...))`. Nenhuma exceção
/// de infraestrutura escapa da camada `data` (docs/ARCHITECTURE.md §6).
Future<Either<Failure, T>> guardDatabase<T>(Future<T> Function() run) async {
  try {
    return Right(await run());
  } on Failure catch (failure) {
    return Left(failure);
  } catch (error) {
    return Left(DatabaseFailure(error.toString(), cause: error));
  }
}
