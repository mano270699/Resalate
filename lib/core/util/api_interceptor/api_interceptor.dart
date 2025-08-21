import 'dart:convert';
import 'package:dio/dio.dart';

import '../../common/models/failure.dart';
import 'package:flutter/foundation.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String headers = "";
    options.headers.forEach((key, value) {
      headers += "$key: $value | \n";
    });
    debugPrint(
        "┌------------------------------------------------------------------------------");
    debugPrint('''| Request: ${options.method} ${options.uri}''');
    debugPrint(
        "├------------------------------------------------------------------------------");
    debugPrint('''| Headers: $headers''');
    debugPrint(
        "├------------------------------------------------------------------------------");
    debugPrint('''| Body: ${options.data}''');
    debugPrint(
        "├------------------------------------------------------------------------------");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    JsonEncoder encoder = const JsonEncoder.withIndent('        ');
    String prettyPrint = encoder.convert(response.data);
    debugPrint("| Status code: ${response.statusCode}");
    debugPrint(
        "├------------------------------------------------------------------------------");
    debugPrint("| Response: $prettyPrint");
    debugPrint(
        "└------------------------------------------------------------------------------");
    debugPrint(
        "================================================================================");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        "| Error response: ${err.response?.data.toString()} ${err.response!.data['error']}--- ${err.response!.data['message']}");
    debugPrint(
        "└------------------------------------------------------------------------------");
    debugPrint(
        "================================================================================");

    throw Failure(err.response!.data['message'] ??
        err.response!.data['error'] ??
        err.response!.data['errors'].toString());
  }
}
