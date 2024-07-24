// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, no_leading_underscores_for_local_identifiers, unnecessary_import

import 'package:chat_app/pages/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout(){
    final _auth = Authservice();
    _auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    return UserAccountsDrawerHeader(
                      accountName: Text(currentUser.displayName ?? 'Loading'),
                      accountEmail: Text(currentUser.email ?? ''),
                      currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage('images/userAvatar.jpg'),
                      ),
                    );
                  } else {
                     return Text('Error: No user logged in');
                  }
                }
              ),
              
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(color: Theme.of(context).colorScheme.background),
                    ),
                  leading: Icon(Icons.home, color: Theme.of(context).colorScheme.background),
                  onTap: (){},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  title: Text(
                    "S E T T I N G", 
                    style: TextStyle(color: Theme.of(context).colorScheme.background),
                    ),
                  leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.background),
                  onTap: (){
                    Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => SettingPage())
                  );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 25),
            child: ListTile(
              title: Text("L O G O U T",
              style: TextStyle(color: Theme.of(context).colorScheme.background),
              ),
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.background),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
