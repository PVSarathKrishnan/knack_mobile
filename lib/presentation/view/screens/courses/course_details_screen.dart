import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knack/data/models/booking_model.dart';
import 'package:knack/data/models/course_model.dart';
import 'package:knack/data/repositories/course_repo.dart';
import 'package:knack/data/repositories/user_repo.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/courses/widgets/payment_confirmation.dart';
import 'package:knack/presentation/view/screens/homescreen/home_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailScreen({Key? key, required this.course});

  @override
  Widget build(BuildContext context) {
    double screeHeight = MediaQuery.of(context).size.height;
    double screeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 6,
        onPressed: () {
          _freeOrNot(context, course);
        },
        splashColor: Color.fromARGB(255, 14, 171, 0),
        label: Text(
          int.parse(course.amount) == 0 ? "Enroll for free" : "Buy this course",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: screeHeight / 3.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(course.title))),
              background: Image.network(
                course.photo,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    course.title,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    course.overview,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  // SizedBox(height: 10),
                  // Text(
                  //   'This course provides comprehensive knowledge on various topics. '
                  //   'It consists of ${course.chapters.length} chapters covering subjects such as ${course.description.join(", ")}. '
                  //   'You will learn through engaging lectures, practical examples, and hands-on exercises. '
                  //   'By the end of this course, you will have a strong understanding of the subject matter '
                  //   'and be well-prepared to apply your knowledge in real-world scenarios.',
                  //   style: TextStyle(fontSize: 18, color: Colors.black),
                  // ),
                  // Display course chapters
                  SizedBox(height: 20),
                  Text(
                    'Chapters:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      course.chapters.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_right,
                              color: g,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                course.chapters[index],
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Display course description
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrice(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: PaymentConfirmationWidget(course: course, context: context),
        );
      },
    );
    // _goToCourse(course, context);
  }

  void _freeOrNot(BuildContext context, CourseModel course) {
    // current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      CourseRepo().getMyCourses(userId).then((List<BookingModel> myCourses) {
        // Check if the course is in the user's courses
        bool courseBought =
            myCourses.any((booking) => booking.course_id == course.courseID);

        if (courseBought) {
          // If the course is already in the user's courses, show a message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have already bought this course.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // If the course is not in the user's courses, proceed as usual
          if (int.parse(course.amount) > 0) {
            _showPrice(context);
          } else {
            _goToCourse(course, context);
          }
        }
      }).catchError((error) {
        print("Error getting user's courses: $error");
      });
    } else {
      print("User ID is null.");
    }
  }

  void _goToCourse(CourseModel course, BuildContext context) {
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => HomeScreen(),
    //     ));
  }
}
