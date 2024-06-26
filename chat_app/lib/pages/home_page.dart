// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_import, non_constant_identifier_names, unused_field

import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/services/chat_services.dart';
import'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatService _chatService =  ChatService();
  final Authservice _AuthService =  Authservice();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }
  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStream(), 
      builder: (context, snapshot){
        if (snapshot.hasError){
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading.....");
        }
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(
            userData, context
          )).toList(),
        );
      });
  }
  Widget _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context){
      if(userData["email"] != _AuthService.getCurrentUser()!.email){
        return UserTile(
        text: userData["email"], 
        onTap: (){
         Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ChatPage(
            receiverEmail: userData["email"],
            receiverID: userData["uid"],
          )
           )
         );
        },
      );
      } else {
        return Container();
      }
    }
}