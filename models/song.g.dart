// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      id: json['id'] as String,
      songName: json['songName'] as String,
      artistName: json['artistName'] as String,
      albumArtImagePath: json['albumArtImagePath'] as String,
      audioPath: json['audioPath'] as String,
      isFavorited: json['isFavorited'] as bool? ?? false,
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'id': instance.id,
      'songName': instance.songName,
      'artistName': instance.artistName,
      'albumArtImagePath': instance.albumArtImagePath,
      'audioPath': instance.audioPath,
      'isFavorited': instance.isFavorited,
    };
