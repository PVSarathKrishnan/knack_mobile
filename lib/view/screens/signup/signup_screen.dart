import 'package:flutter/material.dart';
import 'package:knack/services/auth_service.dart';

import 'package:knack/view/screens/login/login_screen.dart';
import 'package:knack/view/screens/collections.dart';
import 'package:knack/view/screens/profile/profile_build.dart';
import 'package:knack/view/style/text_style.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  bool _isHidden = true;
  bool _isHiddenC = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFAFBFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sign Up", style: text_style_h.copyWith(fontSize: 40)),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Email", style: text_style_n),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validateEmail,
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
                      height: 20,
                    ),
                    Text("Password", style: text_style_n),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: _isHidden,
                      obscuringCharacter: "*",
                      controller: passwordController,
                      validator: _validatePassword,
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
                      height: 20,
                    ),
                    Text("Confirm Password", style: text_style_n),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      obscureText: _isHiddenC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscuringCharacter: "*",
                      controller: cPasswordController,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffix: InkWell(
                            onTap: _togglePasswordViewForConfirmPassword,
                            child: Icon(
                              !_isHiddenC
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
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _signUp,
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
                  "Sign Up",
                  style: text_style_n.copyWith(
                      fontSize: 22, fontWeight: FontWeight.w900),
                )),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
              child: Text(
                "Already have an account,Log in",
                style: text_style_n.copyWith(color: Colors.blue),
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

  void _togglePasswordViewForConfirmPassword() {
    setState(() {
      _isHiddenC = !_isHiddenC;
    });
  }

  _goToHome() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BuildProfile(),
        ));
  }

  _signUp() async {
    if (_formKey.currentState!.validate()) {
      final user = await _auth.createUserWithEmailAndPassword(
          emailController.text, passwordController.text);
      print(user);
      if (user != null) {
        print("success");
        _goToHome();
      }
    }
  }
}
