import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_music/models/user.dart';

class UserApiClient {
  final Dio dio;

  UserApiClient()
      : dio = Dio(BaseOptions(
          baseUrl: 'http://172.26.80.1:8080',
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 3),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      Response response = await dio.post('/users/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioError(
          requestOptions: RequestOptions(path: '/users/login'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioErrorType.badResponse,
        );
      }
    } catch (e) {
      print('Error: $e');
      if (e is DioError) {
        throw e;
      } else {
        throw DioError(
          requestOptions: RequestOptions(path: '/users/login'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<Map<String, dynamic>> register(
      String newUsername, String newEmail, String newPassword, String newAvatarUrl) async {
    try {
      Response response = await dio.post('/users/register', data: {
        'username': newUsername,
        'email': newEmail,
        'password': newPassword,
        'avatarUrl': newAvatarUrl,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioError(
          requestOptions: RequestOptions(path: '/users/register'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioErrorType.badResponse,
        );
      }
    } catch (e) {
      print('Error: $e');
      if (e is DioError) {
        throw e;
      } else {
        throw DioError(
          requestOptions: RequestOptions(path: '/users/register'),
          error: 'Unknown error',
        );
      }
    }
  }

 Future<Map<String, dynamic>> updateUser(String id, User updatedUser) async {
    try {
      Response response = await dio.put('/users/update_user/$id', data: updatedUser.toJson());

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioError(
          requestOptions: RequestOptions(path: '/users/update_user/$id'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioErrorType.badResponse,
        );
      }
    } catch (e) {
      print('Error: $e');
      if (e is DioError) {
        throw e;
      } else {
        throw DioError(
          requestOptions: RequestOptions(path: '/users/update_user/$id'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<String> uploadAudio(File audioFile) async {
    String fileName = audioFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(audioFile.path, filename: fileName),
    });
    Response response = await dio.post('/api/audio/upload', data: formData);
    return response.data; // 返回文件访问 URL
  }
}
