import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/login/login_screen.dart';
import 'package:knack/presentation/view/style/text_style.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  Future _passwordReset() async {
    // First, check if the email is in the database
    bool emailExists = await _checkEmailExists();

    if (!emailExists) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
                "Email not found in our database.,Try signup with this mail"),
          );
        },
      );
      return; // Exit the function if email is not found
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Password reset link sent to your email!"),
          );
        },
      );
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<bool> _checkEmailExists() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text.trim())
          .get();
      // If the querySnapshot contains any documents, the email exists
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle errors, such as FirebaseExceptions or FirestoreExceptions
      print("Error checking email existence: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                        width: screenWidth / 2.3,
                        height: screenWidth / 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.navigate_before_rounded,
                              color: Colors.white,
                            ),
                            Text(
                              "Back to login",
                              style: text_style_n.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ))),
                SizedBox(
                  height: screenHeight / 12,
                ),
                SvgPicture.asset(
                  "lib/assets/reset.svg",
                  width: screenHeight / 4,
                  height: screenHeight / 4,
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Don't worry, we've got you covered.",
                    style: text_style_h.copyWith(fontSize: 20),
                  ),
                  Text(
                    "Just enter your email, and we'll send a verification link.",
                    style: text_style_n.copyWith(fontSize: 18),
                  ),
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  TextFormField(
                    validator: _validateEmail,
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: g.withOpacity(.3)),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: g.withOpacity(.8)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _passwordReset,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Send Reset Link",
                            style: text_style_n.copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  SizedBox(height: screenHeight / 10),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
