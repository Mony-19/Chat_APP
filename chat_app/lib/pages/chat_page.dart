import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key, 
    required this.receiverEmail,
    required this. receiverID,
    }
  );
  //text controller
  final TextEditingController _messagesController = TextEditingController();

  //chat and auth service
  final ChatService _chatService = ChatService();
  final Authservice _authService = Authservice();
  void sendMessage() async {
    if (_messagesController.text.isNotEmpty){
      await _chatService.sendMessage(receiverID, _messagesController.text);
    }
    //clear text controller
    _messagesController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(child: _buildMessageList()),
          //user input
          _builderUserInput(),
        ],
      ),
    );
  }
  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID,senderID), 
      builder: (context, snapshot){
        if (snapshot.hasError){
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading.....");
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc, context)).toList(),
        );
      });
  }
  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    //align message to the right if the sender is the current user, otherwise left
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child:
        ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
    );
  }
  Widget _builderUserInput(){
    return Row
    (children: [
      //textfield
      Expanded(child: MyTextField(
        hintText: "Enter Your Message", 
        obscureText: false, 
        controller: _messagesController)
        ),
      //send button
      IconButton(
        onPressed: sendMessage, 
        icon: Icon(Icons.arrow_upward)
        )
      ],
    );
  }
}