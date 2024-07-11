import 'package:flutter/material.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '主页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow),
          label: '正在播放',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          label: '每日推歌',
        ),
        BottomNavigationBarItem(
          //menu button
          icon: Icon(Icons.menu),
          label: '播放列表',
        ),
      ],
      selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}