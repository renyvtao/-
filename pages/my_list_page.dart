import 'package:flutter/material.dart';
import 'package:flutter_music/models/user_provider.dart';
import 'package:flutter_music/pages/edit_profile_page.dart';
import 'package:flutter_music/pages/re_login_page.dart';
import 'package:flutter_music/themes/theme_provider.dart'; // 导入主题提供器
import 'package:provider/provider.dart';

class Mylistpage extends StatelessWidget {
  const Mylistpage({Key? key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final String avatarPath = user.avatarUrl;
    final themeProvider = Provider.of<ThemeProvider>(context); // 获取主题提供器

    // 将密码转换为星号的方法
    String getMaskedPassword(String password) {
      return '*' * password.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('个人信息'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: themeProvider.themeData.cardColor, // 使用主题中的卡片颜色
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 显示头像图片
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(avatarPath),
                    radius: 50.0,
                  ),
                ),
                SizedBox(height: 24.0),
                _buildInfoRow('用户ID', user.id.toString(), themeProvider.themeData),
                SizedBox(height: 16.0),
                _buildInfoRow('用户名', user.username, themeProvider.themeData),
                SizedBox(height: 16.0),
                _buildInfoRow('邮箱', user.email, themeProvider.themeData),
                SizedBox(height: 16.0),
                _buildInfoRow('密码', getMaskedPassword(user.password), themeProvider.themeData),
                SizedBox(height: 16.0),
                _buildInfoRow('管理级别', user.managementLevel.toString(), themeProvider.themeData),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('修改信息'),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReLoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('切换账号'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData themeData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: themeData.colorScheme.inversePrimary, // 使用主题中的文本颜色
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18.0,
              color: themeData.colorScheme.inversePrimary, // 使用主题中的文本颜色
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
