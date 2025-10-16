abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

/// Failure for server/API related errors
class ServerFailure extends Failure {
  ServerFailure([super.message = "Server error occurred"]);
}

/// Failure for network related errors (no internet, timeout, etc.)
class NetworkFailure extends Failure {
  NetworkFailure([super.message = "Network connection failed"]);
}

/// Failure for repository related errors
class RepositoryFailure extends Failure {
  RepositoryFailure([super.message = "Data operation failed"]);
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  ValidationFailure([super.message = "Validation failed"]);
}

/// Failure for not found errors
class NotFoundFailure extends Failure {
  NotFoundFailure([super.message = "Resource not found"]);
}
