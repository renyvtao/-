import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadAudioPage extends StatelessWidget {
  final Function(String) onAudioSelected;

  const UploadAudioPage({required this.onAudioSelected, Key? key}) : super(key: key);

  Future<void> _pickAudioFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      onAudioSelected(result.files.single.path!);
      Navigator.pop(context); // 返回上一个页面
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择音频文件'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.audiotrack,
                size: 100.0,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _pickAudioFile(context),
                child: Text(
                  '选择音频文件',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
