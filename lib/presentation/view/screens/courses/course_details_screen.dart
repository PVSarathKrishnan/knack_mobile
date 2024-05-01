import 'package:flutter/material.dart';
import 'package:knack/data/models/course_model.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/courses/widgets/payment_confirmation.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailScreen({Key? key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 6,
        onPressed: () => _showPrice(context),
        splashColor: Color.fromARGB(255, 14, 171, 0),
        label: Text(
          int.parse(course.amount) == 0 ? "Enroll for free" : "Buy this course",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              // title: Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(color: g),
              //     child: Text(course.title)),
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

                  SizedBox(height: 10),
                  Text(
                    'This course provides comprehensive knowledge on various topics. '
                    'It consists of ${course.chapters.length} chapters covering subjects such as ${course.description.join(", ")}. '
                    'You will learn through engaging lectures, practical examples, and hands-on exercises. '
                    'By the end of this course, you will have a strong understanding of the subject matter '
                    'and be well-prepared to apply your knowledge in real-world scenarios.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
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
  }
}
