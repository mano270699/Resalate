import 'dart:io';

import 'package:dio/dio.dart';

class ResponseError {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";

    if (error is SocketException) {
      errorDescription = 'Check your internet connection!';
    } else if (error is DioException) {
      switch (error.type) {
        case DioException.connectionError:
          if (error.response?.data['errors'] != null) {
            final e = error.response?.data['errors'];
            if (e is List) {
              errorDescription = e[0]['message'];
            } else {
              errorDescription = 'Something went wrong, please try again';
            }
          } else {
            errorDescription = 'Something went wrong, please try again';
          }
        case DioExceptionType.badCertificate:
          errorDescription = "Something went wrong, please try again!";
          break;
        case DioExceptionType.badResponse:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = "Send timeout with server";
        case DioExceptionType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioExceptionType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioExceptionType.connectionError:
          errorDescription = "Something went wrong, please try again";
          break;
        case DioExceptionType.unknown:
          errorDescription = "Something went wrong, please try again!";
          break;
      }
    } else {
      errorDescription = "Something went wrong, please try again!";
    }

    return errorDescription;
  }
}
