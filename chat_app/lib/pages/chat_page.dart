import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';
import 'package:super_context_menu/super_context_menu.dart';


class ChatPage extends StatelessWidget {
  final String receiverID;
  final String receiverName;
  ChatPage({
    super.key, 
    required this. receiverID,
    required this.receiverName,
    }
  );
  //text controller
  final TextEditingController _messagesController = TextEditingController();

  //chat and auth service
  final ChatService _chatService = ChatService();
  final Authservice _authService = Authservice();
  void sendMessage() async {
    if (_messagesController.text.isNotEmpty){
      await _chatService.sendMessage(receiverID, _messagesController.text, receiverName);
    }
    //clear text controller
    _messagesController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: Text(receiverName),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blue[700],
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(child: _buildMessageList()),
          //user input
          _builderUserInput(context),
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

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Container(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ContextMenuWidget(
        child: ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
        menuProvider: (_) {
        return Menu(
            children: [
              MenuAction(title: 'Reply', callback: () {}),
                MenuAction(title: 'Delete',callback: () {}),
                MenuAction(title: 'Copy', callback: () {}),
                MenuSeparator(),
                Menu(title: 'Submenu', children: [
                  MenuAction(title: 'Submenu Item 1', callback: () {}),
                  MenuAction(title: 'Submenu Item 2', callback: () {}),
                  Menu(title: 'Nested Submenu', children: [
                    MenuAction(title: 'Submenu Item 1', callback: () {}),
                    MenuAction(title: 'Submenu Item 2', callback: () {}),
                  ]),
                ]),
              ],
            );
          },
        ),
      ),
    ),
  );
}

  Widget _builderUserInput(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
      children: [
        //textfield
        Expanded(child: MyTextField(
          hintText: "Enter Your Message", 
          obscureText: false, 
          controller: _messagesController)
          ),
        //send button
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[700],
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
          ),
        ],
      ),
    );
  }
}