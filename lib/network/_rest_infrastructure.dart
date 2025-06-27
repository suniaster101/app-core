import 'dart:io';

import 'package:appcore/errors/errors.dart';
import 'package:appcore/services/_session_service.dart';
import 'package:appcore/utils/utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum Methods { get, post, put, delete, patch }

class Rest {
  String baseURL;
  Rest({required this.baseURL});
  PersistCookieJar cookieJar = PersistCookieJar();

  Future<void> prepareJar() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
  }

  Dio _dio() {
    final options = BaseOptions(
      baseUrl: baseURL,
      followRedirects: false,
    );

    var dio = Dio(options);
    dio.interceptors.add(CookieManager(cookieJar));

    // if (env != Env.production) {
    dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      compact: true,
      responseHeader: false,
    ));
    // }

    return dio;
  }

  Future<Map<String, String>> header(bool useToken) async {
    Map<String, String> header = {
      'Accept': 'application/json',
      'Accept-Language': Session.i.language,
    };
    if (useToken) {
      header['Authorization'] = "Bearer ${await Session.i.getToken()}";
    }
    return header;
  }

  Dio get dio => _dio();

  Future<Response?> get(
    String url, {
    bool useToken = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await executeRequest(
      url,
      requestMethod: Methods.get,
      queryParameters: queryParameters,
      options: Options(headers: await header(useToken)),
    );
    return response;
  }

  Future<Response?> post(String url,
      {bool useToken = true,
      required Map<String, dynamic> data,
      Map<String, List<File>>? files}) async {
    if (files != null) {
      for (var param in files.keys) {
        data[param] = files[param]!.length == 1
            ? await MultipartFile.fromFile(files[param]![0].path,
                filename: files[param]![0].path.split('/').last)
            : files[param]!.map((file) async {
                return await MultipartFile.fromFile(file.path,
                    filename: file.path.split('/').last);
              }).toList();
      }
    }
    var response = await executeRequest(
      url,
      requestMethod: Methods.post,
      data: files != null ? FormData.fromMap(data) : data,
      options: Options(headers: await header(useToken)),
    );
    return response;
  }

  Future<Response?> put(String url,
      {bool useToken = true,
      required Map<String, dynamic> data,
      Map<String, List<File>>? files}) async {
    var response = await executeRequest(
      url,
      requestMethod: Methods.put,
      data: files != null ? FormData.fromMap(data) : data,
      options: Options(headers: await header(useToken)),
    );
    return response;
  }

  Future<Response?> patch(String url,
      {bool useToken = true,
      required Map<String, dynamic> data,
      Map<String, List<File>>? files}) async {
    if (files != null) {
      for (var param in files.keys) {
        data[param] = files[param]!.length == 1
            ? await MultipartFile.fromFile(files[param]![0].path,
                filename: files[param]![0].path.split('/').last)
            : files[param]!.map((file) async {
                return await MultipartFile.fromFile(file.path,
                    filename: file.path.split('/').last);
              }).toList();
      }
    }
    var response = await executeRequest(
      url,
      requestMethod: Methods.patch,
      data: files != null ? FormData.fromMap(data) : data,
      options: Options(headers: await header(useToken)),
    );
    return response;
  }

  Future<Response?> delete(String url,
      {bool useToken = true, dynamic data}) async {
    var response = await executeRequest(url,
        requestMethod: Methods.delete,
        data: data,
        options: Options(headers: await header(useToken)));
    return response;
  }

  Future<Response?> executeRequest(
    String url, {
    required Methods requestMethod,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Function(int, int)? onSendProgress,
    Options? options,
  }) async {
    Response? response;
    try {
      switch (requestMethod) {
        case Methods.get:
          response = await dio.get(url,
              options: options, queryParameters: queryParameters);
          break;

        case Methods.post:
          response = await dio.post(url,
              options: options, data: data, onSendProgress: onSendProgress);
          break;

        case Methods.patch:
          response = await dio.patch(url,
              options: options, data: data, onSendProgress: onSendProgress);
          break;

        case Methods.put:
          response = await dio.put(url,
              options: options, data: data, onSendProgress: onSendProgress);
          break;

        case Methods.delete:
          response = await dio.delete(url, options: options, data: data);
          break;
      }
      return response;
    } on SocketException {
      response?.data['message'] = "No internet connections";
      // rethrow;
      throw RestException(
        message: "Connection Unavailable",
        description:
            "We are currently experiencing issues connecting to an external service. Please try again later.",
      );
      // return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        try {
          response =
              await dio.post("$baseURL/api/v1/auth/refresh", options: options);
          var accessToken = response.data?["data"]?["accessToken"];
          if (accessToken != null) {
            Session.i.saveUserCridentials(token: accessToken);
          }
        } on DioException catch (e) {
          // if unauthenticated / login session is expired, logout user
          if (e.response?.statusCode == 401) {
            await Session.i.logout();
            return null;
          }
        }
        // Retry request after refresh access token
        executeRequest(
          url,
          requestMethod: requestMethod,
          data: data,
          onSendProgress: onSendProgress,
          options: options,
          queryParameters: queryParameters,
        );
      }
      // response = e.response;
      Log.e(e.response?.data?["errors"]);
      final errors = e.response?.data?["errors"];
      String? message = e.response?.data?["message"];
      String? description;
      if (errors is Map) {
        if (errors.isNotEmpty) {
          description = errors.values.first.toString();
        }
      }
      Log.e(description);
      throw RestException(
        message: message ?? "Something is not working properly",
        description: description,
      );
    } catch (e) {
      Log.e(e);
      rethrow;
    }
  }
}
