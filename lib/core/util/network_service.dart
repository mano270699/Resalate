import 'package:dio/dio.dart';

import '../base/dependency_injection.dart';
import 'enums.dart';

abstract class NetworkService {
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers,
      ResponseTypeEnum? responseType});
  Future<Response> post(String url, dynamic data,
      {Map<String, dynamic>? headers});
  Future<Response> delete(String url,
      {dynamic data, Map<String, dynamic>? headers});

  Future<Response> put(String url, dynamic data,
      {Map<String, dynamic>? headers});
  Future<Response> download(
    String url,
    dynamic savePath, {
    Map<String, dynamic>? headers,
    dynamic data,
  });
}

class NetworkServiceImpl implements NetworkService {
  final dio = sl<Dio>();
  @override
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers,
      ResponseTypeEnum? responseType}) async {
    final response = await dio.get(url,
        queryParameters: queryParams,
        options: Options(
            headers: headers,
            responseType: (responseType == ResponseTypeEnum.bytes)
                ? ResponseType.bytes
                : ResponseType.json));
    return response;
  }

  @override
  Future<Response> post(String url, dynamic data,
      {Map<String, dynamic>? headers}) async {
    final response =
        await dio.post(url, data: data, options: Options(headers: headers));
    return response;
  }

  @override
  Future<Response> put(String url, dynamic data,
      {Map<String, dynamic>? headers}) async {
    final response =
        await dio.put(url, data: data, options: Options(headers: headers));
    return response;
  }

  @override
  Future<Response> download(String url, savePath,
      {Map<String, dynamic>? headers, data}) async {
    final response = await dio.download(url, savePath,
        data: data, options: Options(headers: headers));
    return response;
  }

  @override
  Future<Response> delete(
    String url, {
    data,
    Map<String, dynamic>? headers,
  }) async {
    final response = await dio.delete(
      url,
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }
}
