import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../common/models/error_model.dart';
import '../../common/models/failure.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String headers = "";
    options.headers.forEach((key, value) {
      headers += "$key: $value | \n";
    });
    log("┌------------------------------------------------------------------------------");
    log('''| Request: ${options.method} ${options.uri}''');
    log("├------------------------------------------------------------------------------");
    log('''| Headers: $headers''');
    log("├------------------------------------------------------------------------------");
    log('''| Body: ${options.data}''');
    log("├------------------------------------------------------------------------------");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    JsonEncoder encoder = const JsonEncoder.withIndent('        ');
    String prettyPrint = encoder.convert(response.data);
    log("| Status code: ${response.statusCode}");
    log("├------------------------------------------------------------------------------");
    log("| Response: $prettyPrint");
    log("└------------------------------------------------------------------------------");
    log("================================================================================");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("| Error: ${err.error}");
    log("├------------------------------------------------------------------------------");
    log("| Error response: ${err.response?.data.toString()}");
    log("└------------------------------------------------------------------------------");
    log("================================================================================");
    if (err.error is SocketException) {
      throw Failure('');
    }

    if (err.response!.statusCode == 400 && err.response!.data == '') {
      throw Failure('');
    }
    ErrorModel errorModel = ErrorModel.fromJson(err.response!.data);
    // printLog(err.response!.statusCode.toString());
    // printLog(err.response!.data.toString());
    // printLog(err.requestOptions.path.toString());
    // printLog(errorModel.toString());
    throw Failure(errorModel.code.toString());
  }
}
