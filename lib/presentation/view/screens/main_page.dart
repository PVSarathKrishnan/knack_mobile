import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knack/presentation/view/screens/bottom_navigation_bar.dart';
import 'package:knack/presentation/view/screens/choice/auth_bool.dart';
import 'package:knack/presentation/view/screens/choice/google_register.dart';
import 'package:knack/presentation/view/screens/choice/login_signup_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (isGoogleRegistering) {
            // If Google registration is in progress, show a loading indicator or a screen indicating the registration process
            return GoogleRegisterScreen(); // Replace with the appropriate screen for showing Google registration progress
          } else if (snapshot.hasData) {
            return BNBPage(); // User is signed in
          } else {
            return LoginSignupPage(); // User is not signed in
          }
        },
      ),
    );
  }
}
