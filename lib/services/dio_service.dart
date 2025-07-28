import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

class DioService {
  // 🔹 Singleton
  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;

  late final Dio _dio;

  DioService._internal() {
    _dio = Dio(
      BaseOptions(
          baseUrl: 'http://34.100.191.117:8002/',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10)
          // ⚠️  Do NOT hard-set contentType here; let each request decide
          ),
    );

    // Interceptors (same as before)
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (opt, h) {
          print("➡️ ${opt.method} ${opt.uri}");
          if (opt.path == '/check_liveness') {
            opt.baseUrl = 'http://85.31.225.239:8080/';
          } else {
            opt.baseUrl = 'http://34.100.191.117:8002/';
          }
          return h.next(opt);
        },
        onResponse: (res, h) {
          print("✅ ${res.statusCode} ${res.requestOptions.uri}");
          return h.next(res);
        },
        onError: (e, h) {
          print("⛔ ${e.response?.statusCode} ${e.requestOptions.uri}");
          return h.next(e);
        },
      ),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => print(o),
      ),
    ]);
  }

  Dio get client => _dio;

  // ───────────────────────────────────────────
  // 📦 Standard HTTP helpers
  // ───────────────────────────────────────────
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    try {
      final response =
          _dio.get(path, queryParameters: queryParameters, options: options);
      return response;
    } on DioException catch (e) {
      log('DioException: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        log('Response: ${e.response?.data}');
        throw Exception('Network timeout. Please try again later.');
      }
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(path,
          data: data, queryParameters: queryParameters, options: options);
      return response;
    } on DioException catch (e) {
      log('DioException: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        log('Response: ${e.response?.data}');
        throw Exception('Network timeout. Please try again later.');
      }
      rethrow;
    }
  }

  // ───────────────────────────────────────────
  // 🆕 MULTIPART / FILE-UPLOAD HELPER
  // ───────────────────────────────────────────
  /// Upload files or mixed form-fields with `multipart/form-data`.
  ///
  /// ```dart
  /// final file = await MultipartFile.fromFile(
  ///   '/path/image.jpg',
  ///   filename: 'avatar.jpg',
  /// );
  ///
  /// final res = await DioService().postMultipart(
  ///   '/users/upload',
  ///   data: {
  ///     'name': 'Jane',
  ///     'avatar': file,
  ///   },
  /// );
  /// ```
  Future<Response> postMultipart(
    String path, {
    Map<String, dynamic> data = const {},
    required Map<String, List<File>> files,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      final Map<String, dynamic> formMap = {};
      log('files............... ${files.entries.length}');
      // Add all data fields
      formMap.addAll(data);

      // Process the files: each map has field name -> list of files
      for (var entry in files.entries) {
        String fieldName = entry.key;
        List<File> fileList = entry.value;

        // Convert files to MultipartFile and add to form map
        formMap[fieldName] = await Future.wait(
          fileList.map((file) async {
            return MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last);
          }),
        );
        log(' $fieldName : ${formMap[fieldName]}');
      }

      final formData = FormData.fromMap(formMap);

      // Ensure content type is multipart/form-data
      final multipartOptions = (options ?? Options()).copyWith(
        contentType: 'multipart/form-data',
      );

      final res = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: multipartOptions,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return res;
    } on DioException catch (e) {
      log('DioException: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        log('Response: ${e.response?.data}');
        throw Exception('Network timeout. Please try again later.');
      }
      rethrow;
    }
  }
}
