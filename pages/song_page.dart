import 'package:flutter/material.dart';
import 'package:flutter_music/components/new_box.dart';
import 'package:flutter_music/controller/page_manager.dart';
import 'package:flutter_music/models/favorite_provider.dart';
import 'package:flutter_music/models/playlist_provider.dart';
import 'package:flutter_music/models/user_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({Key? key});

  // 转换时间
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // 获取播放列表
        final playlist = value.playlist;
        // 获取当前歌曲索引
        final currentSongIndex = value.currentSongIndex;
        final favoritesProvider =
            Provider.of<FavoritesProvider>(context, listen: false);
        final userProvider =
            Provider.of<UserProvider>(context, listen: false); // 获取 UserProvider 实例
        final userId = userProvider.user.id; // 获取 userId

        // 如果没有正在播放的歌曲，则显示当前未选择任何歌曲
        if (currentSongIndex == null || playlist.isEmpty) {
          if (value.isPlaying) {
            value.pause();
          }
          return Scaffold(
            appBar: AppBar(title: const Text("未选择音乐")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("当前未选择任何歌曲"),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        }

        // 获取当前歌曲
        final currentSong = playlist[currentSongIndex];

        // 异步检查当前歌曲是否已被收藏
        return FutureBuilder<bool>(
          future: favoritesProvider.isFavorite(userId, currentSong.id),
          builder: (context, snapshot) {
            bool isFavorited = snapshot.data ?? false; // 默认为未收藏状态
            // 返回 Scaffold UI
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
                          IconButton(
                            onPressed: () =>
                                Provider.of<PageManager>(context, listen: false)
                                    .changePage(0),
                            icon: const Icon(Icons.arrow_back),
                          ),

                          // 居中显示正在播放的文本
                          Center(
                            child: const Text(
                              '正在播放',
                              style: TextStyle(
                                fontSize: 24, // 增大字体大小
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 25),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Album artwork
                      NewBox(
                        child: Column(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          currentSong.albumArtImagePath,
          width: 400, // 设置封面图片的宽度
          height: 200, // 设置封面图片的高度
        ),
                            ),

                            // Song and artist name and icon
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Song and artist name
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentSong.songName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(currentSong.artistName),
                                    ],
                                  ),
                                  // Heart icon
                                  IconButton(
                                    icon: Icon(
                                      isFavorited
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorited ? Colors.red : null,
                                    ),
                                    onPressed: () {
                                      favoritesProvider.toggleFavorite(
                                          currentSong, userId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Song duration progress
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                // Start and end time
                                Text(formatTime(value.currentDuration)),
                                IconButton(
  icon: Icon(
    value.isRepeating ? Icons.repeat : Icons.repeat_one,
    color: value.isRepeating ? Colors.green : null,
  ),
  onPressed: () {
    value.toggleRepeat();
  },
),

IconButton(
  icon: Icon(
    value.isShuffling ? Icons.shuffle : Icons.shuffle,
    color: value.isShuffling ? Colors.green : null,
  ),
  onPressed: () {
    value.toggleShuffle();
  },
),
                                // End time
                                Text(formatTime(value.totalDuration)),
                              ],
                            ),
                          ),

                          // Song duration progress
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape:
                                  const RoundSliderThumbShape(enabledThumbRadius: 0),
                            ),
                            child: Slider(
                              min: 0,
                              max: value.totalDuration.inSeconds.toDouble(),
                              value: value.currentDuration.inSeconds.toDouble(),
                              activeColor: Colors.green,
                              onChanged: (double newValue) {
                                
                                
                              },
                              onChangeEnd: (double newValue) {
                                // Sliding has finished, go to that position
                                value.seek(Duration(seconds: newValue.toInt()));
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Playback controls
                      Row(
                        children: [
                          // Skip previous
                          Expanded(
                            child: GestureDetector(
                              onTap: value.playPreviousSong,
                              child: const NewBox(
                                child: Icon(Icons.skip_previous),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),
                          // Play/pause
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: value.pauseOrResume,
                              child: NewBox(
                                child: Icon(
                                    value.isPlaying ? Icons.pause : Icons.play_arrow),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),
                          // Skip forward
                          Expanded(
                            child: GestureDetector(
                              onTap: value.playNextSong,
                              child: const NewBox(
                                child: Icon(Icons.skip_next),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
