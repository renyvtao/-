import 'package:flutter/material.dart';
import 'package:flutter_music/pages/my_list_page.dart';
import 'package:flutter_music/pages/settings_page.dart';
class MyDrawer extends StatelessWidget{
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Icon(
              Icons.music_note,
              size: 40,
              color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25),
            child: ListTile(
              title: const Text("主 页"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 0),
            child: ListTile(
              title: const Text("个人信息"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Mylistpage()
                ));
              },
            ),
          ),

          

          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 0),
            child: ListTile(
              title: const Text("设 置"),
            leading: const Icon(Icons.settings),
            onTap: (){
              Navigator.pop(context);

              Navigator.push(context, MaterialPageRoute(builder: (Context) => SettingPage(),
              ),
              );
            },
            ),
          ),

          
      ],
      ),
    );
  }
}