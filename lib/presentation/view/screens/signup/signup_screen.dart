import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/presentation/utils/loading_widget.dart';
import 'package:knack/presentation/view/screens/main_page.dart';
import 'package:knack/presentation/view/screens/login/login_screen.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/style/text_style.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  bool _signupLoading = false;
  bool _isHidden = true;
  bool _isHiddenC = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0XFFFAFBFB),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sign Up",
                          style: text_style_h.copyWith(fontSize: 40)),
                      SizedBox(
                        height: screenHeight / 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex:
                                2, // Adjust the flex value according to your preference
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name",
                                    style: text_style_n.copyWith(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: nameController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
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
                          SizedBox(width: screenWidth / 25),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Age",
                                    style: text_style_n.copyWith(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  controller: ageController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
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
                        ],
                      ),
                      SizedBox(
                        height: screenHeight / 80,
                      ),
                      Text("Email",
                          style: text_style_n.copyWith(
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: screenHeight / 100,
                      ),
                      TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validateEmail,
                        textInputAction: TextInputAction.next,
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
                        height: screenHeight / 80,
                      ),
                      Text("Password",
                          style: text_style_n.copyWith(
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: _isHidden,
                        obscuringCharacter: "*",
                        controller: passwordController,
                        validator: _validatePassword,
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 80,
                      ),
                      Text("Confirm Password",
                          style: text_style_n.copyWith(
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        obscureText: _isHiddenC,
                        textInputAction: TextInputAction.next,
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
                          suffixIcon: InkWell(
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
                onPressed: _signupLoading ? () {} : signUp,
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
                      child: _signupLoading
                          ? LoadingWidget(option: 1)
                          : Text(
                              "Sign Up",
                              style: text_style_n
                                  .copyWith(fontWeight: FontWeight.bold)
                                  .copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900),
                            )),
                ),
              ),
              SizedBox(
                height: screenHeight / 90,
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
                  "Already a member ? Log in",
                  style:
                      text_style_h.copyWith(fontSize: 12, color: Colors.blue),
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

  void _togglePasswordViewForConfirmPassword() {
    setState(() {
      _isHiddenC = !_isHiddenC;
    });
  }

  _goToHome() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ));
  }

  Future signUp() async {
    //Authentication
    try {
      setState(() {
        _signupLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
    print(nameController.text);
    print(ageController.text);
    print(emailController.text);
    //Add user details
    addUserDetails(nameController.text.trim(), int.parse(ageController.text),
        emailController.text.trim());
  }

  Future addUserDetails(String name, int age, String email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "id": FirebaseAuth.instance.currentUser!.uid,
      "name": name,
      "age": age.toString(),
      "email": email,
    });
    _goToHome();
    setState(() {
      _signupLoading = false;
    });
  }
}
