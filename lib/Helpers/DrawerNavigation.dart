import 'package:flutter/material.dart';
import 'package:flutter_sqflite_app/Screens/CategoryScreen.dart';
import 'package:flutter_sqflite_app/Screens/HomeScreen.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Asad Ullah"),
            accountEmail: Text("au4098@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/salman.jpg",
              ),
            ),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          ListTile(
            title: Text("Categories"),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen()));
            },
          ),
        ],
      ),
    );
  }
}
