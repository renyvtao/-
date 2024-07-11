import 'package:flutter/material.dart';
import 'package:flutter_music/models/user.dart';
import 'package:flutter_music/models/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('修改信息'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 头像编辑
              Center(
                child: Stack(
                  children: [
                    _buildAvatarImage(user),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: 实现头像编辑功能
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
              // 显示用户名
              TextField(
                decoration: InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                controller: TextEditingController(text: user.username),
                onChanged: (value) {
                  userProvider.user.username = value;
                },
              ),
              SizedBox(height: 16.0),
              // 显示邮箱
              TextField(
                decoration: InputDecoration(
                  labelText: '邮箱',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                controller: TextEditingController(text: user.email),
                onChanged: (value) {
                  userProvider.user.email = value;
                },
              ),
              SizedBox(height: 16.0),
              // 显示密码
              TextField(
                decoration: InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
                controller: TextEditingController(text: user.password),
                onChanged: (value) {
                  userProvider.user.password = value;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  // 更新用户信息并调用后端接口
                  await userProvider.updateUserInfo(
                    userProvider.user.username,
                    userProvider.user.email,
                    userProvider.user.password,
                    userProvider.user.avatarUrl,
                  );

                  // 返回到原来的页面
                  Navigator.pop(context);
                },
                child: Text('保存'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarImage(User user) {
  // 检查头像地址是否为网络地址，如果是，则返回网络头像；否则返回默认头像
  if (user.avatarUrl.startsWith('http')) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(user.avatarUrl),
    );
  } else {
    return CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage(user.avatarUrl), 
    );
  }
}
}
