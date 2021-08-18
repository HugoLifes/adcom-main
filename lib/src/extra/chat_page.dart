import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          'Chat',
          style: TextStyle(),
        ),
      ),
    );
  }
}

class ChatForm extends StatefulWidget {
  ChatForm({Key? key}) : super(key: key);

  @override
  _ChatFormState createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  @override
  Widget build(BuildContext context) {
    return BodyChat();
  }
}

class BodyChat extends StatefulWidget {
  BodyChat({Key? key}) : super(key: key);

  @override
  _BodyChatState createState() => _BodyChatState();
}

class _BodyChatState extends State<BodyChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
