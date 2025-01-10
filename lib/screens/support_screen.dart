import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesture_firebase_user/utilities&Services/chat_service.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';
import 'package:vesture_firebase_user/widgets/message_bubble.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class SupportScreen extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserId;
  const SupportScreen(
      {super.key,
      required this.recieverUserEmail,
      required this.recieverUserId});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'Live Support'),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildMessageinput()],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8, left: 16, right: 16),
        child: messageBubble(
            data['message'], data['senderId'] == _auth.currentUser!.uid),
      ),
    );
  }

  Widget _buildMessageinput() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            controller: _messageController,
            hintText: 'Enter Message',
            obscureText: false,
          ),
        )),
        IconButton(
            onPressed: sendMessage, icon: Icon(FontAwesomeIcons.caretRight))
      ],
    );
  }

  _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.recieverUserId, _auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('error');
          }
          return ListView(
              children: snapshot.data!.docs
                  .map((document) => _buildMessageItem(document))
                  .toList());
        });
  }
}
