import 'package:flutter/material.dart';
import 'package:flutter_music/models/playlist_provider.dart';
import 'package:flutter_music/models/song.dart';
import 'package:flutter_music/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CurrentPlaylistPage extends StatelessWidget {
  const CurrentPlaylistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);
    final playlist = playlistProvider.playlist;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('当前播放列表'),
        centerTitle: true,
      ),
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final Song movedSong = playlist.removeAt(oldIndex);
          playlist.insert(newIndex, movedSong);
          playlistProvider.setPlaylist(List<Song>.from(playlist));
          playlistProvider.updateCurrentSongIndex(oldIndex, newIndex);
        },
        children: playlist.asMap().entries.map((entry) {
          final index = entry.key;
          final song = entry.value;
          return InkWell(
            key: ValueKey(song.id),
            onTap: () {
              playlistProvider.currentSongIndex = index;
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: themeProvider.themeData.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      song.albumArtImagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.songName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeData.textTheme.bodyText1!.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          song.artistName,
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.themeData.textTheme.bodyText2!.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
