import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:knack/firebase_options.dart';
import 'package:knack/view/screens/bottom_navigation_bar.dart';
import 'package:knack/view/screens/chat/choise/choiseScreen.dart';
import 'package:knack/view/screens/collections.dart';
import 'package:knack/view/screens/login/login_screen.dart';
import 'package:knack/view/screens/signup/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: false,
          appBarTheme: AppBarTheme(
            backgroundColor: g,
            centerTitle: true,
          )),
      debugShowCheckedModeBanner: false,
      title: 'Knack',
      home: LoginSignupPage(),
    );
  }
}
