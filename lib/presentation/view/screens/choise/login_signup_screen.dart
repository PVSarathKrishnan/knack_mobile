import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knack/presentation/view/screens/bottom_navigation_bar.dart';
import 'package:knack/presentation/view/screens/choise/google_register.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/login/login_screen.dart';
import 'package:knack/presentation/view/screens/signup/signup_screen.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:knack/presentation/view/widgets/custom_snackbar.dart';
import 'package:lottie/lottie.dart';

class LoginSignupPage extends StatelessWidget {
  LoginSignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hey, Welcome to ",
                  style: text_style_h.copyWith(fontSize: 20, letterSpacing: 3),
                ),
                Text(
                  "Knack!",
                  style: text_style_h.copyWith(
                      fontSize: 20, letterSpacing: 3, color: Colors.deepOrange),
                ),
              ],
            ),
            Lottie.asset("lib/assets/auth.json", height: 150, width: 150),
            SizedBox(
              height: 25,
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
                width: screenWidth - screenWidth / 7,
                height: screenHeight / 15,
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
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 100,
            ),
            Text(
              "or",
              style: text_style_n,
            ),
            SizedBox(
              height: screenHeight / 100,
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
                width: screenWidth - screenWidth / 7,
                height: screenHeight / 15,
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
            SizedBox(
              height: screenHeight / 30,
            ),
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
                width: screenWidth - screenWidth / 7,
                height: screenHeight / 15,
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
          ],
        ),
      ),
    );
  }

  _googleSignin(BuildContext context) async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        // Check if the user is new
        bool userExists = await checkIfUserExists(user);

        if (userExists) {
          // Existing user, navigate to home
          _goToHome(context);
          CustomSnackBar(content: "Welcome");
        } else {
          // New user, navigate to GoogleRegisterScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoogleRegisterScreen()),
          );
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

// Navigate to home page
  _goToHome(BuildContext context) {
    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BNBPage()),
    );
  }

  Future<bool> checkIfUserExists(User? user) async {
    if (user == null) return false;

    try {
      // Retrieve user data from Firestore collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: user.email)
          .get();

      // Check if any documents exist with the given email
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }
}
