import 'package:flutter/material.dart';
import 'package:flutter_music/components/custom_bottom_navigation_bar.dart';
import 'package:flutter_music/controller/page_manager.dart';
import 'package:flutter_music/models/favorite_provider.dart';
import 'package:flutter_music/models/playlist_provider.dart';
import 'package:flutter_music/models/user_provider.dart';
import 'package:flutter_music/pages/admin_page.dart';
import 'package:flutter_music/pages/current_playlist_page.dart';
import 'package:flutter_music/pages/daily_rec_page.dart';
import 'package:flutter_music/pages/home_page.dart';
import 'package:flutter_music/pages/login_page.dart';
import 'package:flutter_music/pages/my_like_page.dart';
import 'package:flutter_music/pages/song_page.dart';
import 'package:flutter_music/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => PlaylistProvider()),
      ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => PageManager()),
    ],
    child: Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: userProvider.isLoggedIn ? '/home' : '/login',
          routes: {
            '/login': (context) => LoginPage(),
            '/home': (context) =>
                userProvider.user.managementLevel == 1 ? AdminPage() : MyApp(),
          },
        );
      },
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void _onItemTapped(int index) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<ThemeProvider>(context),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: Scaffold(
              body: Consumer<PageManager>(
                builder: (context, pageManager, child) {
                  return IndexedStack(
                    index: pageManager.selectedPage,
                    children: [
                      HomePage(),
                      SongPage(),
                      MyLikePage(),
                      DailyRecommendationPage(),
                      CurrentPlaylistPage(),
                    ],
                  );
                },
              ),
              bottomNavigationBar: CustomBottomNavigationBar(
                currentIndex: Provider.of<PageManager>(context).selectedPage,
                onTap: (index) {
                  Provider.of<PageManager>(context, listen: false)
                      .changePage(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
