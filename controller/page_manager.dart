import 'package:flutter/material.dart';

class PageManager with ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  void changePage(int page) {
    _selectedPage = page;
    notifyListeners();
  }
}