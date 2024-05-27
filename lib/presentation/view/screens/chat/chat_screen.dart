import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import 'package:knack/presentation/view/screens/collections.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? previousDate;

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  final DatabaseReference chatRef =
      FirebaseDatabase.instance.ref().child('community');

  final TextEditingController _content = TextEditingController();

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(const Duration(milliseconds: 600), () {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
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
        FirebaseDatabase.instance.ref().child('community');
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
        actions: [
          IconButton(
              onPressed: () {
                _scrollToBottom();
              },
              icon: const Icon(Icons.arrow_drop_down)),
          IconButton(
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              icon: const Icon(Icons.light_mode_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight - screenHeight / 3.5,
              width: screenWidth,
              child: StreamBuilder(
                key: UniqueKey(),
                stream: chatRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    List<dynamic> list = map.values.toList();
                    for (var chat in list) {
                      if (chat['dateTime'] is String) {
                        chat['dateTime'] = DateTime.parse(chat['dateTime']);
                      }
                    }
                    list.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
                    list = list.reversed.toList();
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = list[index]['dateTime'];
                        String formattedTime =
                            DateFormat('h:mm a').format(dateTime);
                        String messageDate =
                            list[index]['dateTime'].toString().substring(0, 10);
                        bool displayDate = false;
                        if (previousDate == null ||
                            messageDate != previousDate) {
                          displayDate = true;
                          previousDate = messageDate;
                        }
                        DateTime parsedDate = DateTime.parse(messageDate);
                        String formattedDate =
                            DateFormat('dd MMM yyyy').format(parsedDate);

                        return Column(
                          crossAxisAlignment:
                              list[index]['senderId'] == user!.uid
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            if (displayDate)
                              Center(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    messageDate == currentDateString
                                        ? "Today"
                                        : formattedDate,
                                    style: DateTextStyle(),
                                  ),
                                ),
                              ),
                            ChatBubble(
                              clipper: ChatBubbleClipper1(
                                type: list[index]['senderId'] == user!.uid
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment: list[index]['senderId'] == user!.uid
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 10),
                              backGroundColor:
                                  list[index]['senderId'] == user!.uid
                                      ? Colors.green
                                      : const Color(0xffE7E7ED),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (list[index]['senderId'] != user!.uid)
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(list[index]['avatar']),
                                        radius: 10,
                                      ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: list[index]['content_type'] ==
                                              "text"
                                          ? Text(
                                              list[index]['content'],
                                              style: TextStyle(
                                                color: list[index]
                                                            ['senderId'] ==
                                                        user!.uid
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16,
                                              ),
                                            )
                                          : Container(
                                              height: 100,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      list[index]['content']),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                    ),
                                    if (list[index]['senderId'] == user!.uid)
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(list[index]['avatar']),
                                        radius: 10,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment:
                                  list[index]['senderId'] == user!.uid
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                if (list[index]['senderId'] != user!.uid)
                                 
                                if (list[index]['senderId'] != user!.uid)
                                  const SizedBox(width: 5),
                                Text(
                                  formattedTime,
                                  style: TimeTextStyle(),
                                ),
                                if (list[index]['senderId'] == user!.uid)
                                  const SizedBox(width: 5),
                                if (list[index]['senderId'] == user!.uid)
                                  Text(
                                    "| You",
                                    style: TimeTextStyle(),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else {
                    return Center(
                      child: Text(
                        "Chat responsibly",
                        style: GoogleFonts.orbitron(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 80, left: 8, right: 8),
              child: TextFormField(
                controller: _content,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  fillColor: v.withOpacity(.1),
                  filled: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Map<String, dynamic> data = {
                              "senderId": user?.uid,
                              "avatar": user?.photoURL ??
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                              "content_type": "text",
                              "content": _content.text.trim(),
                              "dateTime": DateTime.now().toIso8601String(),
                            };
                            sendMessage(context, data);
                          },
                          icon: const Icon(Icons.send),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle DateTextStyle() => GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey);

  TextStyle TimeTextStyle() {
    return GoogleFonts.poppins(
      fontSize: 10,
    );
  }

  void sendMessage(BuildContext context, Map<String, dynamic> data) async {
    print(_content);
    await databaseReference
        .child('community')
        .push()
        .set(data)
        .whenComplete(() {
      print("object");
    });
    _content.clear();
  }
}
