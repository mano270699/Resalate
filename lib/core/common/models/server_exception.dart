import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String errorMessage;
  final String? errorCode;

  const ServerException({
    required this.errorMessage,
    this.errorCode,
  });

  @override
  List<Object?> get props => [errorCode, errorMessage];
}
