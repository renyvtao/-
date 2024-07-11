import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_music/models/song.dart';

class SongApiClient {
  final Dio dio;

  SongApiClient()
      : dio = Dio(BaseOptions(
          baseUrl: 'http://172.26.80.1:8080',
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 3),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  Future<Song> addSong(Song song) async {
    try {
      Response response = await dio.post('/songs', data: song.toJson());

      if (response.statusCode == 201) {
        return Song.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('添加歌曲出错: $e');
      if (e is DioException) {
        throw e;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<Song> updateSong(String id, Song updatedSong) async {
    try {
      Response response =
          await dio.put('/songs/$id', data: updatedSong.toJson());

      if (response.statusCode == 200) {
        return Song.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs/$id'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('更新歌曲出错: $e');
      if (e is DioException) {
        throw e;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs/$id'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<void> deleteSong(String id) async {
    try {
      Response response = await dio.delete('/songs/$id');

      if (response.statusCode != 204) {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs/$id'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('删除歌曲出错: $e');
      if (e is DioException) {
        throw e;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs/$id'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<List<Song>> getAllSongs() async {
    try {
      Response response = await dio.get('/songs');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Song.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('获取所有歌曲出错: $e');
      if (e is DioException) {
        throw e;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<List<Song>> getSongsByPage(int page, int size) async {
    try {
      Response response =
          await dio.get('/songs/page?page=$page&size=$size');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['content'];
        return jsonList.map((json) => Song.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs/page?page=$page&size=$size'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('按页获取歌曲出错: $e');
      if (e is DioException) {
        throw e;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/songs/page?page=$page&size=$size'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<List<Song>> getRandomSongs(int count) async {
    try {
      List<Song> allSongs = await getAllSongs();
      if (allSongs.length <= count) {
        return allSongs;
      }

      var random = Random();
      Set<int> indexes = {};
      while (indexes.length < count) {
        indexes.add(random.nextInt(allSongs.length));
      }

      return indexes.map((index) => allSongs[index]).toList();
    } catch (e) {
      print('获取随机歌曲出错: $e');
      throw e;
    }
  }

  Future<void> addFavorite(String userId, String songId) async {
    try {
      Response response = await dio.post('/favorites/$userId/$songId');
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: RequestOptions(path: '/favorites/$userId/$songId'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('添加收藏出错: $e');
      if (e is DioException) {
        throw e;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/favorites/$userId/$songId'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<void> removeFavorite(String userId, String songId) async {
  try {
    Response response = await dio.delete('/favorites/$userId/$songId');
    if (response.statusCode != 204) {
      throw DioException(
        requestOptions: RequestOptions(path: '/favorites/$userId/$songId'),
        response: response,
        error: 'Http status error [${response.statusCode}]',
        type: DioExceptionType.badResponse,
      );
    }
  } catch (e) {
    print('移除收藏出错: $e');
    throw e; // 继续抛出异常以便上层处理
  }
}


  Future<List<Song>> getUserFavorites(String userId) async {
    try {
      Response response = await dio.get('/favorites/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Song.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/favorites/$userId'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('获取用户收藏出错: $e');
      if (e is DioException) {
        throw e;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/favorites/$userId'),
          error: 'Unknown error',
        );
      }
    }
  }

  Future<bool> isFavorite(String userId, String songId) async {
    try {
      Response response = await dio.get('/favorites/$userId/$songId/isFavorite');
      if (response.statusCode == 200) {
        return response.data as bool;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/favorites/$userId/$songId/isFavorite'),
          response: response,
          error: 'Http status error [${response.statusCode}]',
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('检查收藏状态出错: $e');
      if (e is DioException) {
        throw e;
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/favorites/$userId/$songId/isFavorite'),
          error: 'Unknown error',
        );
      }
    }
  }
}
