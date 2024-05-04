import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knack/bloc/fetch_bloc/bloc/fetch_course_bloc.dart';
import 'package:knack/presentation/view/screens/choise/login_signup_screen.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:knack/presentation/view/widgets/under_construction_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    context.read<FetchCourseBloc>().add(MyCoursesLoadEvent(uid: currentUser));
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home"),
        actions: [],
      ),
      body: BlocBuilder<FetchCourseBloc, FetchCourseState>(
        builder: (context, state) {
          if (state is MyCoursesLoadedState) {
            return SizedBox(
              height: screenHeight - screenHeight / 7,
              width: screenWidth - 40,
              child: ListView.builder(
                itemCount: state.myCourseList.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        child: Text(
                          state.myCourseList[index].course_title,
                          style: text_style_h,
                        ),
                      ));
                },
              ),
            );
          } else if (state is MyCoursesErrorState) {
            return Column(
              children: [
                SizedBox(
                  height: screenHeight / 4,
                ),
                Text(
                  "No Active Subscriptions",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                // AnimatedIcon(icon: AnimatedIcons.ellipsis_search, progress:kAlwaysCompleteAnimation,size: 50,color: Colors.grey,)
              ],
            );
          } else {
            return SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight / 80,
                      ),
                      Text("data"),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red)),
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
            ));
          }
        },
      ),
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
