import 'package:flutter/material.dart';
import 'package:knack/view/style/text_style.dart';
import 'package:knack/view/widgets/under_construction_widget.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is Course Page',
              style: text_style_h,
            ),
            UCWidget
          ],
        ),
      ),
    );
  }
}
