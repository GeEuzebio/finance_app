import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/errors/failure.dart';
import '../../cashflow_engine/presentation/projection_providers.dart';
import '../domain/entities/reserve.dart';
import '../domain/repositories/reserve_repository.dart';
import '../domain/usecases/contribute_to_reserve.dart';
import '../domain/usecases/create_reserve.dart';
import '../domain/usecases/withdraw_from_reserve.dart';

part 'reserves_providers.g.dart';

@riverpod
ReserveRepository reserveRepository(Ref ref) => getIt<ReserveRepository>();
@riverpod
CreateReserve createReserveUseCase(Ref ref) => getIt<CreateReserve>();
@riverpod
ContributeToReserve contributeToReserveUseCase(Ref ref) => getIt<ContributeToReserve>();
@riverpod
WithdrawFromReserve withdrawFromReserveUseCase(Ref ref) => getIt<WithdrawFromReserve>();

@riverpod
class ReservesController extends _$ReservesController {
  @override
  Future<List<Reserve>> build() async {
    final result = await ref.read(reserveRepositoryProvider).getAll();
    return result.match((failure) => throw failure, (reserves) => reserves);
  }

  Future<void> createReserve(Reserve reserve) => _run(
        () => ref.read(createReserveUseCaseProvider).call(reserve),
      );

  Future<void> contribute(String reserveId, int amountCents) => _run(
        () => ref
            .read(contributeToReserveUseCaseProvider)
            .call(reserveId: reserveId, amountCents: amountCents),
      );

  Future<void> withdraw(String reserveId, int amountCents) => _run(
        () => ref
            .read(withdrawFromReserveUseCaseProvider)
            .call(reserveId: reserveId, amountCents: amountCents),
      );

  Future<void> deleteReserve(String reserveId) => _run(
        () => ref.read(reserveRepositoryProvider).delete(reserveId),
      );

  Future<void> _run(Future<Either<Failure, Unit>> Function() action) async {
    final result = await action();
    result.match((failure) => throw failure, (_) => null);
    ref.invalidateSelf();
    ref.invalidate(monthlyProjectionProvider);
    ref.invalidate(dayLedgerProvider);
    await future;
  }
}
