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
    final searchController = TextEditingController();

    context.read<FetchCourseBloc>().add(FetchCourseLoadedEvent());
    return Scaffold(
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
          BlocBuilder<FetchCourseBloc, FetchCourseState>(
            builder: (context, state) {
              if (state is FetchCourseLoadedState) {
                return Expanded(
                  child: ListView.builder(
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
                  ),
                );
              } else if (state is SearchLoadedState) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.searchedCourseList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailScreen(
                                course: state.searchedCourseList[index],
                              ),
                            ),
                          );
                        },
                        child:
                            CourseCard(course: state.searchedCourseList[index]),
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
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          controller: controller,
          onChanged: (value) {
            context
                .read<FetchCourseBloc>()
                .add(SearchCourseEvent(searchWord: value));
          },
          decoration: InputDecoration(
            hintText: 'Search Courses',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
