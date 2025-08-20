class ErrorModel {
  final String referenceNumber;
  final String message;
  final String code;

  ErrorModel({
    required this.referenceNumber,
    required this.message,
    required this.code,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> map) {
    return ErrorModel(
      referenceNumber: map['errors'][0]['referenceNumber'] ?? '',
      message: map['errors'][0]['message'] ?? '',
      code: map['errors'][0]['errorCode'] ?? '',
    );
  }
  @override
  String toString() {
    return 'ErrorModel(referenceNumber: $referenceNumber, message: $message, code: $code)';
  }
}
