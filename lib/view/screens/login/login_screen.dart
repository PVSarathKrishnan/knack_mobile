import 'package:flutter/material.dart';
import 'package:knack/services/auth_service.dart';
import 'package:knack/view/screens/homescreen/home_screen.dart';
import 'package:knack/view/screens/collections.dart';
import 'package:knack/view/screens/signup/signup_screen.dart';
import 'package:knack/view/style/text_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isHidden = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFAFBFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Login", style: text_style_h.copyWith(fontSize: 40)),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Email", style: text_style_n),
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
                      height: 20,
                    ),
                    Text("Password", style: text_style_n),
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
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: 350,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:g),
                child: Center(
                    child: Text(
                  "Login",
                  style: text_style_n.copyWith(
                      fontSize: 22, fontWeight: FontWeight.w900),
                )),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "or",
              style: text_style_n,
            ),
            SizedBox(
              height: 3,
            ),
            ElevatedButton(
              onPressed: _googleSignin,
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

  _googleSignin() {
    AuthService.signInWithGoogle(context: context);
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
      builder: (context) => HomeScreen(),
    ));
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      final user = await _auth.signInUserWithEmailAndPassword(
          emailController.text, passwordController.text);
      print(user);
      if (user != null) {
        print("success");
        _gotoHome();
      }
    }
  }
}
