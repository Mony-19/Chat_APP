
// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/components/custom_Search.dart';
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
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: const Text("Messages"),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blue[700],
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton( 
                icon: Icon(Icons.search),
                onPressed: (){
                  showSearch(context: context, delegate: CustomSearch());
                },
              ),
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
      
      body: Expanded(
              child: _buildUserList()
          ),
      );
  }
 Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getChatRoomsStream(), 
      builder: (context, snapshot){
        if (snapshot.hasError){
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading.....");
        }
        return ListView(
          children: snapshot.data!.map<Widget>((chatRoomData) => _buildUserListItem(
            chatRoomData, context
          )).toList(),
        );
      });
  }
  Widget _buildUserListItem(Map<String, dynamic> chatRoomData, BuildContext context) {
    String currentUserID = _AuthService.getCurrentUser()!.uid;
    bool isCurrentUserInvolved = chatRoomData["senderID"] == currentUserID || chatRoomData["receiverID"] == currentUserID;

    if (isCurrentUserInvolved) {
      return UserTile(
        text: chatRoomData["receiverName"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverID: chatRoomData["receiverID"],
                receiverName: chatRoomData["receiverName"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}