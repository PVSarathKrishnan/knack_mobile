import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knack/bloc/fetch_bloc/bloc/fetch_course_bloc.dart';
import 'package:knack/presentation/utils/loading_widget.dart';
import 'package:knack/presentation/view/screens/choice/login_signup_screen.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/courses/learn_course_screen.dart';
import 'package:knack/presentation/view/style/text_style.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    context.read<FetchCourseBloc>().add(MyCoursesLoadEvent(
          uid: currentUser,
        ));
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width; //
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: BlocBuilder<FetchCourseBloc, FetchCourseState>(
        builder: (context, state) {
          if (state is MyCoursesLoadedState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Text(
                        "Your Courses",
                        style: text_style_h.copyWith(fontSize: 22),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: screenHeight / 1.5,
                    child: ListView.builder(
                      itemCount: state.myCourseList.length,
                      itemBuilder: (context, index) {
                        final course = state.myCourseList[index];
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LearnCoursePage(course: course),
                                  ));
                            },
                            contentPadding: EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                course.course_photo,
                                fit: BoxFit.cover,
                                height: screenHeight / 5,
                                width: screenHeight / 8,
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      truncateText(course.course_title, 20),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      course.date,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: g,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          } else if (state is MyCoursesErrorState) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight / 4),
                  Column(
                    children: [
                      Image.network(
                        "https://i.pinimg.com/564x/3b/16/5c/3b165c92c38143d6165b2de473860720.jpg",
                        //https://i.pinimg.com/564x/4a/36/e1/4a36e13be90a120f4d2ee0b0b2441fb9.jpg - chat
                        // https://i.pinimg.com/564x/c6/8a/69/c68a6998c232492b4fa5da39f1638f2a.jpg - trending courses
                        height: screenHeight / 3,
                        width: screenHeight / 3,
                      ),
                      Container(
                        child: Text("Ready to stand out? Learn a course and land your dream job!",style: GoogleFonts.orbitron(),),
                      ),
                      
                    ],
                  )
                ],
              ),
            );
          } else {
            return Center(child: LoadingWidget(option: 2));
          }
        },
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupPage()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
  }
}
