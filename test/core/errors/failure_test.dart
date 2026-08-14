import 'package:finance_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cada subtipo de Failure carrega sua mensagem', () {
    expect(const ValidationFailure('inválido').message, 'inválido');
    expect(const NotFoundFailure('não encontrado').message, 'não encontrado');
    expect(const DatabaseFailure('erro de banco').message, 'erro de banco');
    expect(const ProjectionFailure('erro de projeção').message, 'erro de projeção');
  });

  test('DatabaseFailure carrega a causa original opcionalmente', () {
    final cause = Exception('driver error');

    final failure = DatabaseFailure('erro de banco', cause: cause);

    expect(failure.cause, cause);
    expect(const DatabaseFailure('sem causa').cause, isNull);
  });

  test('subtipos de Failure são instâncias de Failure', () {
    const Failure failure = ValidationFailure('x');
    expect(failure, isA<Failure>());
  });
}
