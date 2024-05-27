import 'package:flutter/material.dart';
import 'package:knack/data/models/course_model.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/style/text_style.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({Key? key, required this.course});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth / 2.5,
      child: Card(
        color: Color.fromARGB(255, 248, 248, 248),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth / 3,
                    height: screenWidth / 3.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(course.photo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          truncateString(course.title),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${course.chapters.length} chapters",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          int.parse(course.amount) > 0
                              ? "₹${course.amount}"
                              : "Free",
                          style: text_style_n.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Display crown only if amount is greater than 0
            Positioned(
                top: 10,
                right: 10,
                child: (int.parse(course.amount) > 0)
                    ? Icon(
                        Icons.workspace_premium,
                        color: Color(0XFFC27EEB),
                      )
                    : Text(
                        "Free",
                        style: text_style_n.copyWith(color: Colors.green),
                      )),
            Positioned(
                top: screenHeight / 15,
                right: 20,
                child: Icon(
                  Icons.navigate_next,
                  color: g,
                  size: 30,
                ))
          ],
        ),
      ),
    );
  }

  String truncateString(String input, {int maxLength = 25}) {
    if (input.length > maxLength) {
      return input.substring(0, maxLength) + '...';
    } else {
      return input;
    }
  }
}
