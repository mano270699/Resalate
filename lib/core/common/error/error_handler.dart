import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

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
            debugPrint("Error_ Message::${e['message']}");
            errorDescription = e['message'];
          } else {
            debugPrint(
                "Error_ Message Else::${error.response?.data.toString()}");

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
          errorDescription =
              "Something went wrong, please try again connectionError";
          break;
        case DioExceptionType.unknown:
          errorDescription = "Something went wrong, please try again! unknown";
          break;
      }
    } else {
      errorDescription = "Something went wrong, please try again!  kkksks";
    }

    return errorDescription;
  }
}
