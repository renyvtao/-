import 'package:flutter/material.dart';
import 'package:flutter_music/models/favorite_provider.dart';
import 'package:flutter_music/models/playlist_provider.dart';
import 'package:flutter_music/models/song.dart';
import 'package:flutter_music/services/song_api_provider.dart'; // 导入 SongApiClient
import 'package:provider/provider.dart';

class DailyRecommendationPage extends StatefulWidget {
  const DailyRecommendationPage({Key? key}) : super(key: key);

  @override
  _DailyRecommendationPageState createState() => _DailyRecommendationPageState();
}

class _DailyRecommendationPageState extends State<DailyRecommendationPage> {
  late final PageController _pageController;
  final List<Song> _dailyRecommendationPlaylist = [];

  final SongApiClient songApiClient = SongApiClient(); // 实例化 SongApiClient

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Song> songs = await songApiClient.getRandomSongs(3);
      setState(() {
        _dailyRecommendationPlaylist.clear();
        _dailyRecommendationPlaylist.addAll(songs);
      });
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('每日推歌')),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _dailyRecommendationPlaylist.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              elevation: 4.0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 26.0),
                  child: Text(
                    '左划开启每日推歌',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          } else {
            final song = _dailyRecommendationPlaylist[index - 1];
            return _buildSmallCard(song, index - 1);
          }
        },
        onPageChanged: (int index) {
          if (index > 0) {
            playlistProvider.setPlaylist(_dailyRecommendationPlaylist);
            playlistProvider.currentSongIndex = index - 1;
          }
        },
      ),
    );
  }

  Widget _buildSmallCard(Song song, int index) {
    //final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    //final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    Provider.of<PlaylistProvider>(context, listen: false);
    Provider.of<FavoritesProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Card(
        elevation: 4.0,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(song.albumArtImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(song.songName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(song.artistName, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
