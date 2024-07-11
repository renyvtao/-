import 'package:flutter/material.dart';
import 'package:flutter_music/models/user_provider.dart';
import 'package:provider/provider.dart';

class ReRegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController avatarUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  avatarUrlController.text.isNotEmpty
                      ? avatarUrlController.text
                      : 'https://via.placeholder.com/150',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: '邮箱',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: avatarUrlController,
                decoration: InputDecoration(
                  labelText: '头像链接',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Force rebuild to update avatar preview
                  (context as Element).markNeedsBuild();
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (usernameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      avatarUrlController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('请填写完整注册信息'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    bool registrationSuccess =
                        await Provider.of<UserProvider>(context, listen: false)
                            .register(
                      usernameController.text,
                      emailController.text,
                      passwordController.text,
                      avatarUrlController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(registrationSuccess
                            ? '注册成功'
                            : '注册失败,用户名重复'),
                        duration: Duration(seconds: 3),
                      ),
                    );

                    if (registrationSuccess) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('注册'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
