import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverName;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverName,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });

  //convert to a map
  Map<String, dynamic> toMap(){
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverName': receiverName,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp, 
    };
  }
}