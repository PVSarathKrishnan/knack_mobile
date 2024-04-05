import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/services/auth_service.dart';
import 'package:knack/view/screens/bottom_navigation_bar.dart';
import 'package:knack/view/screens/collections.dart';
import 'package:knack/view/screens/homescreen/home_screen.dart';
import 'package:knack/view/screens/login/login_screen.dart';
import 'package:knack/view/screens/profile/profile_build.dart';
import 'package:knack/view/screens/signup/signup_screen.dart';
import 'package:knack/view/style/text_style.dart';
import 'package:lottie/lottie.dart';

class LoginSignupPage extends StatelessWidget {
   LoginSignupPage({Key? key}) : super(key: key);
    final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hey, Welcome to Knack!",
              style: text_style_n.copyWith(fontSize: 20, letterSpacing: 3),
            ),
            Lottie.asset("lib/assets/auth.json"),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: g, width: 1.5),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: 350,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Center(
                    child: Text(
                  'Login',
                  style: text_style_n.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                )),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to signup page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: 350,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: g),
                child: Center(
                    child: Text(
                  'Signup',
                  style: text_style_n.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                )),
              ),
            ),
            Text(
              "or",
              style: text_style_n,
            ),
            SizedBox(
              height: 3,
            ),
            ElevatedButton(
              onPressed: () {
                _googleSignin(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: 350,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign in with Google  ",
                      style: text_style_n.copyWith(
                          fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    Image.asset(
                      "lib/assets/glogo.png",
                      height: 30,
                      width: 30,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 9,
            ),
          ],
        ),
      ),
    );
  }

  // Google Sign-In method
_googleSignin(BuildContext context) async {
  // Sign in with Google
  User? user = await AuthService.signInWithGoogle(context: context);

  // Check if the user is new or existing
  bool userExists = await checkIfUserExists(user);

  // Navigate based on user existence
  if (userExists) {
    // Existing user, navigate to home
    _goToHome(context);
  } else {
    // New user, navigate to build profile
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBarScreen()),
    );
  }
}

// Navigate to home page
_goToHome(BuildContext context) {
  // Navigate to the home page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => BottomNavBarScreen()),
  );
}

  Future<bool> checkIfUserExists(User? user) async {
    if (user == null) return false;

    try {
      // Retrieve user data from Firebase Authentication
      User? firebaseUser = _auth.currentUser;
      return firebaseUser != null;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }
}
