import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/services/auth_service.dart';
import 'package:knack/view/screens/main_page.dart';
import 'package:knack/view/screens/collections.dart';
import 'package:knack/view/screens/login/forgot_password.dart';
import 'package:knack/view/screens/signup/signup_screen.dart';
import 'package:knack/view/style/text_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isHidden = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
      // Navigate to MainPage after successful login
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    } catch (e) {
      // Handle login errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.toString()),
          );
        },
      );
      print('Login error: $e');
      // Set loading state back to false
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0XFFFAFBFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 190,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login", style: text_style_h.copyWith(fontSize: 40)),
                  SizedBox(
                    height: screenHeight / 30,
                  ),
                  Text("Email",
                      style:
                          text_style_n.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: _validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 60,
                  ),
                  Text("Password",
                      style:
                          text_style_n.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: _isHidden,
                    controller: passwordController,
                    validator: _validatePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      suffix: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            !_isHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          )),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ));
                        },
                        child: Text(
                          'Forgot password?',
                          style: text_style_h.copyWith(
                              fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: signIn,
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
                  "Login",
                  style: text_style_n.copyWith(
                      fontSize: 22, fontWeight: FontWeight.w900),
                )),
              ),
            ),
            SizedBox(
              height: screenHeight / 60,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ));
              },
              child: Text(
                "Don't have an account ? Sign Up",
                style: text_style_h.copyWith(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    final passwordRegExp = RegExp(
      r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$#.*])[A-Za-z\d@$#.*]{6,}$',
    );
    if (!passwordRegExp.hasMatch(value)) {
      return 'Password must include alphabet, number, and special characters';
    }
    return null;
  }

  _gotoHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MainPage(),
    ));
  }
}
