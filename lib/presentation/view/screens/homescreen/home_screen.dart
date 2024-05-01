import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knack/presentation/view/screens/choise/login_signup_screen.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:knack/presentation/view/widgets/under_construction_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight / 80,
                ),
                Text(
                  'Sign in at ${user!.email}',
                  style: text_style_h.copyWith(fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                UCWidget,
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      signOut(context);
                    },
                    child: Text(
                      "Sign Out",
                      style: text_style_h.copyWith(fontSize: 20),
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Sign out of Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out of Google Sign In
      await GoogleSignIn().signOut();

      // Navigate back to the login/signup page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupPage()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
