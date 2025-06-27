part of 'errors.dart';

class Failure {
  late String message;
  String? description;
  int? code;

  Failure({
    required this.message,
    this.code,
    this.description,
  });

  Failure.fromError(Exception error) {
    if (error is RestException) {
      message = error.message;
      description = error.description;
    } else {
      message = error.toString();
    }
  }

  @override
  String toString() => message;
}
