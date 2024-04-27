
import 'package:flutter/material.dart';
import 'package:knack/data/models/course_model.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailScreen({Key? key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(course.photo),
            SizedBox(height: 20),
            Text(
              course.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(course.overview),
            
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text(course.amount==0? "Enroll for free" :"Buy this course"),
            ),
            // Add more detailed course information here
          ],
        ),
      ),
    );
  }
}
