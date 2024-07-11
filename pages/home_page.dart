import 'package:flutter/material.dart';
import 'package:flutter_music/components/my_drawer.dart';
import 'package:flutter_music/controller/page_manager.dart';
import 'package:flutter_music/models/playlist_provider.dart';
import 'package:flutter_music/models/song.dart';
import 'package:flutter_music/services/song_api_provider.dart'; // 导入 SongApiClient
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlaylistProvider playlistProvider;
  final List<Song> songLibPlaylist = [];
  final List<Song> displayedSongs = [];
  final SongApiClient songApiClient = SongApiClient(); // 实例化 SongApiClient
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    // 在 initState 中调用方法获取歌曲数据
    fetchData();
    // 初始化显示列表
    displayedSongs.addAll(songLibPlaylist);
  }

  Future<void> fetchData() async {
    try {
      List<Song> songs = await songApiClient.getAllSongs();
      setState(() {
        songLibPlaylist.clear();
        songLibPlaylist.addAll(songs);
        displayedSongs.clear();
        displayedSongs.addAll(songs);
      });
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  void goToSong(BuildContext context, int songIndex) {
    playlistProvider.setPlaylist(songLibPlaylist);
    //playlistProvider.setPlaylist(displayedSongs);
    playlistProvider.currentSongIndex = songIndex;
    Provider.of<PageManager>(context, listen: false).changePage(1); // SongPage是索引1
  }

  void _filterSongs(String query) {
    final filteredSongs = songLibPlaylist.where((song) {
      final songName = song.songName.toLowerCase();
      final artistName = song.artistName.toLowerCase();
      final searchQuery = query.toLowerCase();

      return songName.contains(searchQuery) || artistName.contains(searchQuery);
    }).toList();

    setState(() {
      displayedSongs.clear();
      displayedSongs.addAll(filteredSongs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          '树莓音乐',
          textAlign: TextAlign.left,
        ),
        titleSpacing: -5,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            margin: EdgeInsets.only(right: 16.0, top: 5.0), // 添加top值来将搜索栏下移

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
  controller: _searchController,
  decoration: InputDecoration(
    hintText: '搜索歌曲...',
    border: InputBorder.none,
    prefixIcon: Icon(Icons.search),
    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10), // 设置上下内边距
  ),
  onChanged: (value) {
    _filterSongs(value);
  },
),
          ),
        ],
        centerTitle: false, // 标题不居中
      ),
      drawer: const MyDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0), // 添加边距
        itemCount: displayedSongs.length,
        itemBuilder: (context, index) {
          final Song song = displayedSongs[index];
          return Card(
            elevation: 4.0, // 添加阴影
            margin: const EdgeInsets.symmetric(vertical: 8.0), // 每个卡片的垂直边距
            child: ListTile(
              title: Text(
                song.songName,
                style: const TextStyle(fontWeight: FontWeight.bold), // 歌名加粗
              ),
              subtitle: Text(song.artistName),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // 圆角图片
                child: Image.asset(
                  song.albumArtImagePath,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios), // 添加箭头图标
              onTap: () => goToSong(context, index),
            ),
          );
        },
      ),
    );
  }
}
