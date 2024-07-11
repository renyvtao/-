import 'package:flutter/material.dart';
import 'package:flutter_music/models/favorite_provider.dart';
import 'package:flutter_music/models/playlist_provider.dart';
import 'package:flutter_music/models/song.dart';
import 'package:flutter_music/models/user.dart';
import 'package:flutter_music/models/user_provider.dart';
import 'package:provider/provider.dart';

class MyLikePage extends StatefulWidget {
  const MyLikePage({Key? key}) : super(key: key);

  @override
  _MyLikePageState createState() => _MyLikePageState();
}

class _MyLikePageState extends State<MyLikePage> {
  bool isShowingFavorites = false;

  @override
  void initState() {
    super.initState();
    // 获取当前用户和收藏歌曲列表
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    
    // 在页面初始化时从后端获取收藏歌曲列表并更新状态
    favoritesProvider.fetchFavorites(userId);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final playlistProvider = Provider.of<PlaylistProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
        centerTitle: true, // 标题居中
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          children: [
            // 用户信息和收藏按钮
            Center(
              child: Column(
                children: [
                  // 头像
                  /*CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl), // 用户头像网络地址
                    radius: 50.0,
                  ),*/
                  _buildAvatarImage(user),
                  SizedBox(height: 16),
                  Text(
                    '用户: ${user.username}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // 显示收藏按钮
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isShowingFavorites = !isShowingFavorites;
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)),
              ),
              child: Text(
                isShowingFavorites ? '收起' : '我喜欢的音乐',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // 如果收藏列表为空，显示一个提示信息
            if (favoritesProvider.favoritesPlaylist.isEmpty && isShowingFavorites)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  '你还没有收藏任何歌曲。',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            // 显示收藏歌曲列表
            if (isShowingFavorites)
              Expanded(
                child: ListView.builder(
                  itemCount: favoritesProvider.favoritesPlaylist.length,
                  itemBuilder: (context, index) {
                    final Song song = favoritesProvider.favoritesPlaylist[index];
                    return Card(
                      elevation: 4.0, // 添加阴影效果
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: _buildLeadingImage(song), // 加载歌曲封面图片
                        ),
                        title: Text(
                          song.songName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(song.artistName),
                        onTap: () {
                          playlistProvider.currentSongIndex = index;
                          playlistProvider.setPlaylist(favoritesProvider.favoritesPlaylist);
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingImage(Song song) {
    // 判断图片地址是否为网络地址
    if (song.albumArtImagePath.startsWith('http')) {
      return Image.network(
        song.albumArtImagePath,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      ); // 网络地址直接使用 NetworkImage
    } else {
      return Image.asset(
        song.albumArtImagePath,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      ); // 非网络地址使用 AssetImage 加载本地资源
    }
  }

  Widget _buildAvatarImage(User user) {
  // 判断头像地址是否为网络地址
  if (user.avatarUrl.startsWith('http')) {
    return CircleAvatar(
      backgroundImage: NetworkImage(user.avatarUrl),
      radius: 50.0,
    );
  } else {
    return CircleAvatar(
      backgroundImage: AssetImage(user.avatarUrl),
      radius: 50.0,
    );
  }
}
}
