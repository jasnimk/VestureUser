import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vesture_firebase_user/models/message_model.dart';

class ChatService extends ChangeNotifier {
  ///get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///SEND MESSAGE
  Future<void> sendMessage(String recieverId, String message) async {
    //get current userinfo
    final String currentUserid = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderId: currentUserid,
        senderEmail: currentUserEmail,
        recieverId: recieverId,
        message: message,
        timestamp: timestamp);

    //construct chat room id from current user id and reciever id (sorted)
    List<String> ids = [currentUserid, recieverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    //add a new message to collection
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  ///GET MESSAGE
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
