import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/date_only.dart';
import '../../cashflow_engine/presentation/projection_providers.dart';
import '../domain/entities/check_in_item.dart';
import '../domain/usecases/adjust_check_in_item.dart';
import '../domain/usecases/cancel_check_in_item.dart';
import '../domain/usecases/confirm_check_in_item.dart';
import '../domain/usecases/get_today_check_in_items.dart';
import '../domain/usecases/postpone_check_in_item.dart';

part 'check_in_providers.g.dart';

@riverpod
GetTodayCheckInItems getTodayCheckInItemsUseCase(Ref ref) => getIt<GetTodayCheckInItems>();
@riverpod
ConfirmCheckInItem confirmCheckInItemUseCase(Ref ref) => getIt<ConfirmCheckInItem>();
@riverpod
AdjustCheckInItem adjustCheckInItemUseCase(Ref ref) => getIt<AdjustCheckInItem>();
@riverpod
CancelCheckInItem cancelCheckInItemUseCase(Ref ref) => getIt<CancelCheckInItem>();
@riverpod
PostponeCheckInItem postponeCheckInItemUseCase(Ref ref) => getIt<PostponeCheckInItem>();

@riverpod
class CheckInController extends _$CheckInController {
  @override
  Future<List<CheckInItem>> build() async {
    final today = DateOnly.fromDateTime(DateTime.now());
    final result = await ref.read(getTodayCheckInItemsUseCaseProvider).call(today: today);
    return result.match((failure) => throw failure, (items) => items);
  }

  Future<void> confirm(CheckInItem item) =>
      _run(() => ref.read(confirmCheckInItemUseCaseProvider).call(item));

  Future<void> adjust(CheckInItem item, int newAmountCents) => _run(
        () => ref
            .read(adjustCheckInItemUseCaseProvider)
            .call(item, newAmountCents: newAmountCents),
      );

  Future<void> cancel(CheckInItem item) =>
      _run(() => ref.read(cancelCheckInItemUseCaseProvider).call(item));

  Future<void> postpone(CheckInItem item, DateOnly newDate) => _run(
        () => ref.read(postponeCheckInItemUseCaseProvider).call(item, newDate: newDate),
      );

  Future<void> _run(Future<Either<Failure, Unit>> Function() action) async {
    final result = await action();
    result.match((failure) => throw failure, (_) => null);
    ref.invalidateSelf();
    ref.invalidate(dailyProjectionProvider);
    await future;
  }
}
