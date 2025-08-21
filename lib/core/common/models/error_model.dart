class ErrorModel {
  final String message;
  final String status;

  ErrorModel({
    required this.message,
    required this.status,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> map) {
    return ErrorModel(
      message: map['message'] ?? '',
      status: map['status'] ?? '',
    );
  }
  @override
  String toString() {
    return 'ErrorModel(message: $message, status: $status)';
  }
}

class DefaultModel {
  final String? message;
  final String? status;

  DefaultModel({
    this.message,
    this.status,
  });

  factory DefaultModel.fromJson(Map<String, dynamic> map) {
    return DefaultModel(
      message: map['message'] ?? '',
      status: map['status'] ?? '',
    );
  }
  @override
  String toString() {
    return 'DefaultModel(message: $message, status: $status)';
  }
}
