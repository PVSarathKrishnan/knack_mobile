import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knack/bloc/fetch_bloc/bloc/fetch_course_bloc.dart';
import 'package:knack/data/models/course_model.dart';
import 'package:knack/presentation/utils/loading_widget.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/courses/course_details_screen.dart';
import 'package:knack/presentation/view/screens/courses/widgets/course_card.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final searchController = TextEditingController();
  String? selectedAmountFilter;

  @override
  Widget build(BuildContext context) {
    context.read<FetchCourseBloc>().add(FetchCourseLoadedEvent());

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
        title: Text("Courses"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(controller: searchController),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterButton(
                label: 'Below \$100',
                onPressed: () {
                  setState(() {
                    selectedAmountFilter = 'below100';
                  });
                },
              ),
              FilterButton(
                label: '\$100 - \$200',
                onPressed: () {
                  setState(() {
                    selectedAmountFilter = '100to200';
                  });
                },
              ),
              FilterButton(
                label: '\$200 - \$300',
                onPressed: () {
                  setState(() {
                    selectedAmountFilter = '200to300';
                  });
                },
              ),
            ],
          ),
          BlocBuilder<FetchCourseBloc, FetchCourseState>(
            builder: (context, state) {
              if (state is FetchCourseLoadedState) {
                final filteredCourses = _filterCourses(state.courseList);
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailScreen(
                                course: filteredCourses[index],
                              ),
                            ),
                          );
                        },
                        child: CourseCard(course: filteredCourses[index]),
                      );
                    },
                  ),
                );
              } else if (state is SearchLoadedState) {
                final filteredCourses =
                    _filterCourses(state.searchedCourseList);
                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailScreen(
                                course: filteredCourses[index],
                              ),
                            ),
                          );
                        },
                        child: CourseCard(course: filteredCourses[index]),
                      );
                    },
                  ),
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
        ],
      ),
    );
  }

  List<CourseModel> _filterCourses(List<CourseModel> courses) {
    if (selectedAmountFilter == 'below100') {
      return courses.where((course) => int.parse(course.amount) < 100).toList();
    } else if (selectedAmountFilter == '100to200') {
      return courses
          .where((course) =>
              int.parse(course.amount) >= 100 &&
              int.parse(course.amount) <= 200)
          .toList();
    } else if (selectedAmountFilter == '200to300') {
      return courses
          .where((course) =>
              int.parse(course.amount) >= 200 &&
              int.parse(course.amount) <= 300)
          .toList();
    }
    return courses;
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FilterButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
