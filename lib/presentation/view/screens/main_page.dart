import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/presentation/view/screens/bottom_navigation_bar.dart';
import 'package:knack/presentation/view/screens/choice/login_signup_screen.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BNBPage(); //index screen/holder screen
            } else {
              return LoginSignupPage();
            }
          }),
    );
  }
}
