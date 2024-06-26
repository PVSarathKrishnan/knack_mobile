import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knack/presentation/view/screens/main_page.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/login/forgot_password.dart';
import 'package:knack/presentation/view/screens/signup/signup_screen.dart';
import 'package:knack/presentation/view/style/text_style.dart';

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
      bool emailExists = await _checkEmailExists(); // Check if email exists
      if (!emailExists) {
        // If email does not exist, show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 182, 0, 0),
          content: Text(
            'Email not found in database',
            style: text_style_n,
          ),
        ));
        setState(() {
          _isLoading = false; // Set loading state back to false
        });
        return;
      }

      // Email exists, proceed with signing in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Navigate to MainPage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
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
    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Color(0XFFFAFBFB),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight / 10),
              SvgPicture.asset(
                "lib/assets/login.svg",
                height: screenHeight / 4,
                width: screenHeight / 4,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
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
                            borderRadius: BorderRadius.circular(5)),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
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
                        suffixIcon: InkWell(
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
                          borderRadius: BorderRadius.circular(5),
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
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: screenWidth - screenWidth / 5,
                  height: screenHeight / 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), color: g),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ?",
                      style: text_style_h.copyWith(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    Text(
                      " Sign Up",
                      style: text_style_h.copyWith(
                          fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
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
