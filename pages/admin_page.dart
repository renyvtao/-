import 'package:flutter/material.dart';
import 'package:flutter_music/models/song.dart';
import 'package:flutter_music/services/song_api_provider.dart';
import 'package:flutter_music/pages/re_login_page.dart';
import 'package:flutter_music/pages/upload_audio_page.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final SongApiClient songApiClient = SongApiClient();
  List<Song> _songs = [];
  List<Song> _filteredSongs = [];
  TextEditingController _songNameController = TextEditingController();
  TextEditingController _artistNameController = TextEditingController();
  TextEditingController _albumArtController = TextEditingController();
  TextEditingController _audioPathController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  Song? _selectedSong;

  @override
  void initState() {
    super.initState();
    fetchSongs();
    _searchController.addListener(_filterSongs);
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('权限被拒绝'),
          content: Text('请授予存储权限以继续使用该功能。'),
          actions: <Widget>[
            TextButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchSongs() async {
    try {
      List<Song> songs = await songApiClient.getAllSongs();
      setState(() {
        _songs = songs;
        _filteredSongs = songs;
      });
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  void _filterSongs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = _songs;
      } else {
        _filteredSongs = _songs.where((song) {
          return song.songName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> addSong() async {
    try {
      Song newSong = Song(
        id: '',
        songName: _songNameController.text,
        artistName: _artistNameController.text,
        albumArtImagePath: _albumArtController.text,
        audioPath: _audioPathController.text,
      );
      await songApiClient.addSong(newSong);
      fetchSongs();
      _clearControllers();
    } catch (e) {
      print('Error adding song: $e');
    }
  }

  Future<void> updateSong() async {
    if (_selectedSong == null) return;
    try {
      Song updatedSong = Song(
        id: _selectedSong!.id,
        songName: _songNameController.text,
        artistName: _artistNameController.text,
        albumArtImagePath: _albumArtController.text,
        audioPath: _audioPathController.text,
      );
      await songApiClient.updateSong(_selectedSong!.id, updatedSong);
      fetchSongs();
      _clearControllers();
      setState(() {
        _selectedSong = null;
      });
    } catch (e) {
      print('Error updating song: $e');
    }
  }

  Future<void> deleteSong(String id) async {
    try {
      await songApiClient.deleteSong(id);
      fetchSongs();
    } catch (e) {
      print('Error deleting song: $e');
    }
  }

  void _clearControllers() {
    _songNameController.clear();
    _artistNameController.clear();
    _albumArtController.clear();
    _audioPathController.clear();
  }

  void _populateControllers(Song song) {
    _songNameController.text = song.songName;
    _artistNameController.text = song.artistName;
    _albumArtController.text = song.albumArtImagePath;
    _audioPathController.text = song.audioPath;
  }

  Widget _buildSongImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.music_note);
        },
      );
    } else {
      return Image.asset(
        imagePath,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.music_note);
        },
      );
    }
  }

  void _openUploadAudioPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadAudioPage(
          onAudioSelected: (path) {
            setState(() {
              _audioPathController.text = path;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SizedBox(
            width: 300,
            height: 40,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '搜索歌曲',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.switch_account),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReLoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSongs.length,
              itemBuilder: (context, index) {
                final song = _filteredSongs[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: _buildSongImage(song.albumArtImagePath),
                    title: Text(song.songName),
                    subtitle: Text(song.artistName),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteSong(song.id),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedSong = song;
                      });
                      _populateControllers(song);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _selectedSong != null ? '编辑歌曲' : '添加新歌曲',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _clearControllers();
                          _selectedSong = null;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _songNameController,
                  decoration: InputDecoration(
                    labelText: '歌曲名',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _artistNameController,
                  decoration: InputDecoration(
                    labelText: '歌手名',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _albumArtController,
                  decoration: InputDecoration(
                    labelText: '专辑封面路径',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.file_upload),
                      onPressed: _openUploadAudioPage,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _audioPathController,
                  decoration: InputDecoration(
                    labelText: '音频路径',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.file_upload),
                      onPressed: _openUploadAudioPage,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: addSong,
                      child: Text('添加歌曲'),
                    ),
                    if (_selectedSong != null)
                      ElevatedButton(
                        onPressed: updateSong,
                        child: Text('更新歌曲'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
