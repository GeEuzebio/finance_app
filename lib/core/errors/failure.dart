sealed class Failure {
  const Failure(this.message);

  final String message;
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {this.cause});

  final Object? cause;
}

class ProjectionFailure extends Failure {
  const ProjectionFailure(super.message);
}
