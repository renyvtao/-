import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/models/song.dart';

class PlaylistProvider extends ChangeNotifier{
  List<Song> _playlist = [];
  void setPlaylist(List<Song> newPlaylist) {
    _playlist = newPlaylist;
    notifyListeners();
  }//更新列表

  //当前播放索引
  int? _currentSongIndex;

  //音频解码
  //音频播放
  final AudioPlayer _audioPlayer = AudioPlayer();
  //持续时间
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // 重复和随机
  bool _isShuffling = false;
  bool _isRepeating = false;

  //构造器
  PlaylistProvider() {
    listenToDuration();
  }
  //初始化
  bool _isPlaying = false;

  //播放
  void play() async{
    if (_currentSongIndex != null) {
      final String path = _playlist[_currentSongIndex!].audioPath;
      await _audioPlayer.stop(); // Stop any current playback
      await _audioPlayer.play(AssetSource(path)); // Play the new song
      _isPlaying = true;
      notifyListeners();
    }
  }

  //暂停
   void pause() async {
    if (_currentSongIndex != null) {
      await _audioPlayer.pause();
      _isPlaying = false;
      notifyListeners();
    }
  }
  //恢复播放
 void resume() async {
    if (_currentSongIndex != null) {
      await _audioPlayer.resume();
      _isPlaying = true;
      notifyListeners();
    }
  }

  //暂停恢复切换
  void pauseOrResume() async{
    if(_isPlaying){
      pause();
    }else{
      resume();
    }
  }
  //定位播放
  void seek(Duration position) async{
    await _audioPlayer.seek(position);
  }

  //切换下一首
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_isRepeating) {
        // 如果是重复播放，保持当前索引不变
        currentSongIndex = currentSongIndex!;
      } else if (_isShuffling) {
        // 如果是随机播放，生成一个新的随机索引
      final random = Random();
      final int index = (random.nextInt(_playlist.length));
       currentSongIndex = (currentSongIndex! + index) % _playlist.length;
      } else if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }
  // 切换上一首
  void playPreviousSong() async {
    if(_currentDuration.inSeconds >2){
      seek(Duration.zero);

    }else{
      if(_currentSongIndex! >0){
        currentSongIndex = _currentSongIndex! -1;
      }else{
        currentSongIndex = _playlist.length -1;
              }
    }
  }

   // 切换歌曲的收藏状态
  void toggleFavorite(int songIndex) {
    _playlist[songIndex].isFavorited = !_playlist[songIndex].isFavorited;
    notifyListeners();
  }

  // 切换 Shuffle 模式
  void toggleShuffle() {
    _isShuffling = !_isShuffling;
    notifyListeners();
  }

  // 切换 Repeat 模式
  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }

  //监听
  void listenToDuration(){
    //监听总持续时间
    _audioPlayer.onDurationChanged.listen((newDuration) { 
      _totalDuration = newDuration;
      notifyListeners();
    });

    //监听当前持续时间
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
     });

    //监听歌曲完成
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });

  }

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
   bool get isShuffling => _isShuffling;
  bool get isRepeating => _isRepeating;

  set currentSongIndex(int? newIndex){
    //更新索引
    _currentSongIndex = newIndex;
    if(newIndex != null){
      play();//播放歌曲
    }

    //更新UI
    notifyListeners();
  }

  void updateCurrentSongIndex(int oldIndex, int newIndex) {
    if (_currentSongIndex == oldIndex) {
      _currentSongIndex = newIndex;
    } else if (oldIndex < _currentSongIndex! && newIndex >= _currentSongIndex!) {
      _currentSongIndex = _currentSongIndex! - 1;
    } else if (oldIndex > _currentSongIndex! && newIndex <= _currentSongIndex!) {
      _currentSongIndex = _currentSongIndex! + 1;
    }
    notifyListeners();
  }
}