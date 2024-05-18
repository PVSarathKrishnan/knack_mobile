import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // XFile? newImage;

  String? previousDate;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final DatabaseReference chatRef =
      FirebaseDatabase.instance.ref().child("community");
  final TextEditingController _content = TextEditingController();
  late ScrollController _scrollController;

  //init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(
      Duration(milliseconds: 600),
      () {
        _scrollToBottom();
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String currentDateString =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    final user = FirebaseAuth.instance.currentUser;
    final DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child("community");
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          IconButton(onPressed: (){
            _scrollToBottom();
          }, icon: const Icon(Icons.arrow_drop_down)),
          IconButton(onPressed: (){
          AdaptiveTheme.of(context).toggleThemeMode();
        }, icon: const Icon(Icons.light_mode_outlined))],
      ),
      body: Center(
        child: Text(
          'This is Chat Page',
          style: text_style_h,
        ),
      ),
    );
  }
}
