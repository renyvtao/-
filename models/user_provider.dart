import 'package:flutter/material.dart';
import 'package:flutter_music/models/user.dart';
import 'package:flutter_music/services/api_provider.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(id: '', username: '', email: '', password: '', avatarUrl: '', managementLevel: 0);
  User get user => _user;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final UserApiClient _userApiClient = UserApiClient();

  Future<void> login(String username, String password) async {
    try {
      Map<String, dynamic> userData = await _userApiClient.login(username, password);
      _user = User.fromJson(userData);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      notifyListeners();
      print('登录失败: $e');
    }
  }

  void logout() {
    _user = User(id: '', username: '', email: '', password: '', avatarUrl: '', managementLevel: 0);
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> updateUserInfo(String username, String email, String password, String avatarUrl) async {
    try {
      User updatedUser = User(
        id: _user.id, // 保持原始ID
        username: username,
        email: email,
        password: password,
        avatarUrl: avatarUrl,
        managementLevel: _user.managementLevel,
      );
      await _userApiClient.updateUser(_user.id, updatedUser);
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('更新用户信息失败: $e');
    }
  }

  Future<bool> register(String newUsername, String newEmail, String newPassword, String newAvatarUrl) async {
    try {
      Map<String, dynamic> userData = await _userApiClient.register(newUsername, newEmail, newPassword, newAvatarUrl);
      _user = User.fromJson(userData);
      _isLoggedIn = true;
      notifyListeners();
      return true; // 注册成功
    } catch (e) {
      print('注册失败: $e');
      return false; // 注册失败
    }
  }
}
