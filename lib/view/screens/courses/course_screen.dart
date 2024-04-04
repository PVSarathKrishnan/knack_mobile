import 'package:flutter/material.dart';
import 'package:knack/view/style/text_style.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course"),
      ),
       body: Center(
        child: Text(
          'This is Course Page',
          style: text_style_h,
        ),
      ),
    );
  }
}
