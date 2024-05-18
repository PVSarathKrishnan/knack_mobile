import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knack/presentation/utils/loading_widget.dart';
import 'package:knack/presentation/view/screens/bottom_navigation_bar.dart';
import 'package:knack/presentation/view/screens/choice/google_register.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/login/login_screen.dart';
import 'package:knack/presentation/view/screens/main_page.dart';
import 'package:knack/presentation/view/screens/signup/signup_screen.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:knack/presentation/view/widgets/custom_snackbar.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({Key? key}) : super(key: key);

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool _googleLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://img.freepik.com/free-vector/access-control-system-abstract-concept-vector-illustration-security-system-authorize-entry-login-credentials-electronic-access-password-passphrase-pin-verification-abstract-metaphor_335657-5746.jpg?t=st=1715238638~exp=1715242238~hmac=a337917bb3db6fcf028542ddb1a762101673e41854f3fc3205344840e2db0110&w=826",
              height: screenHeight / 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey there,",
                  style: text_style_h.copyWith(fontSize: 22, letterSpacing: 3),
                ),
                Text(
                  "Welcome to Knack!",
                  style: text_style_h.copyWith(
                      fontSize: 22, letterSpacing: 3, color: Color(0XFFC27EEB)),
                ),
              ],
            ),
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
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: screenWidth - screenWidth / 7,
                height: screenHeight / 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black),
                child: _googleLoading
                    ? Center(
                        child: LoadingWidget(
                          option: 2,
                        ),
                      )
                    : Row(
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                " or ",
                style: text_style_n,
              ),
            ]),
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
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: screenWidth - screenWidth / 7,
                height: screenHeight / 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
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
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: screenWidth - screenWidth / 7,
                height: screenHeight / 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: g),
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
      setState(() {
        _googleLoading = true;
      });

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
          if (!mounted) return;
          // Existing user, navigate to home
          _goToHome(context);
          CustomSnackBar(content: "Welcome");
          setState(() {
            _googleLoading = false;
          });
        } else {
          if (!mounted) return;
          // New user, navigate to GoogleRegisterScreen
          setState(() {
            _googleLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoogleRegisterScreen()),
          );
        }
      } else {
        if (!mounted) return;
        setState(() {
          _googleLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _googleLoading = false;
      });
      print("Error signing in with Google: $e");
    }
  }

  // Navigate to home page
  _goToHome(BuildContext context) {
    // Navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
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
