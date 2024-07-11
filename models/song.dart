import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

@JsonSerializable()
class Song {
  final String id;
  final String songName;
  final String artistName;
  final String albumArtImagePath;
  final String audioPath;
  bool isFavorited; // 添加一个属性来表示歌曲是否被收藏

  // 构造函数保持不变
  Song({
    required this.id,
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioPath,
    this.isFavorited = false, // 默认不被收藏
  });

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  Map<String, dynamic> toJson() => _$SongToJson(this);
}
