import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knack/bloc/fetch_bloc/bloc/fetch_course_bloc.dart';
import 'package:knack/presentation/utils/loading_widget.dart';
import 'package:knack/presentation/view/screens/courses/course_details_screen.dart';
import 'package:knack/presentation/view/screens/courses/widgets/course_card.dart';

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
              child: LoadingWidget(
                option: 2,
              ),
            ); // Placeholder for loading state
          }
        },
      ),
    );
  }
}
