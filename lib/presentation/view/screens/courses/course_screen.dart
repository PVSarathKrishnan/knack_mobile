import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knack/bloc/fetch_bloc/bloc/fetch_course_bloc.dart';
import 'package:knack/data/models/course_model.dart';
import 'package:knack/presentation/view/screens/courses/course_details_screen.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:knack/presentation/view/widgets/under_construction_widget.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    context.read<FetchCourseBloc>().add(FetchCourseLoadedEvent());
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
      ),
      body: BlocBuilder<FetchCourseBloc, FetchCourseState>(
        builder: (context, state) {
          if (state is FetchCourseLoadedState) {
            return ListView.builder(
              itemCount: state.courseList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailScreen(
                          course: state.courseList[index],
                        ),
                      ),
                    );
                  },
                  child: CourseCard(course: state.courseList[index]),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            ); // Placeholder for loading state
          }
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({Key? key, required this.course});

  @override
  Widget build(BuildContext context) {
    String truncatedDescription = course.overview.length > 10
        ? course.overview.substring(0, 10) + '...'
        : course.overview;
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                        course.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        truncatedDescription,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${course.chapters.length} chapters",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (int.parse(course.amount)>
              0) // Display crown only if amount is greater than 0
            Positioned(
              top: 10,
              right: 10,
              child: Image.asset(
                "lib/assets/premium.png",
                height: 30,
                width: 30,
              ),
            ),
        ],
      ),
    );
  }
}
