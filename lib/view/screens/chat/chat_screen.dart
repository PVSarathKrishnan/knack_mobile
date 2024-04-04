import 'package:flutter/material.dart';
import 'package:knack/view/style/text_style.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat"),),
       body: Center(
        child: Text(
          'This is Chat Page',
          style: text_style_h,
        ),
      ),
    );
  }
}