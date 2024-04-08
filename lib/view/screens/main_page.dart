import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/view/screens/bottom_navigation_bar.dart';

import 'package:knack/view/screens/login/login_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BottomNavBarScreen();//index screen/holder screen
            } else {
              return LoginScreen();
            }
          }),
    );
  }
}
