import 'dart:io';

import 'package:dio/dio.dart';
import 'package:example/services/dio_service.dart';

import 'dart:async';

class FaceService {
  // FaceService._();
  // static final _instance = FaceService._();
  // factory FaceService() => _instance;
  static final _dioService = DioService();

  static Future<Map> registerFace({
    required List<File> images,
    required String name,
  }) async {
    try {
      final res = await _dioService.postMultipart(
        '/register',
        data: {'name': name},
        files: {'files': images},
      );
      final body = res.data as Map;

      if (body['status'] == 'success') {
        return body;
      } else {
        throw Exception(body['message']);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception(e.response?.data['detail'] ?? 'Unknown error occured');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map> recognize({
    required List<File> images,
  }) async {
    try {
      final res = await _dioService.postMultipart(
        '/recognize',
        files: {'files': images},
      );
      final body = res.data as Map;

      if (body['status'] == 'success') {
        return body;
      } else {
        throw Exception(body['message']);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception(e.response?.data['detail'] ?? 'Unknown error occured');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map> checkLiveness({
    required List<File> images,
  }) async {
    try {
      final res = await _dioService.postMultipart(
        '/check_liveness',
        files: {'file': images},
      );
      final body = res.data as Map;

      if (body['face_state']['liveness_score'] != null) {
        return body;
      } else {
        throw Exception('No face detected');
      }
    } catch (e) {
      rethrow;
    }
  }
}
