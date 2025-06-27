part of 'errors.dart';

class RestException implements Exception {
  final String message;
  final String? description;
  RestException({required this.message, this.description});

  @override
  String toString() {
    return message;
  }
}
