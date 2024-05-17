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
    double screeHeight = MediaQuery.of(context).size.height;
    double screeWidth = MediaQuery.of(context).size.width;
    context.read<FetchCourseBloc>().add(FetchCourseLoadedEvent());

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                label: 'Below \₹100',
                onPressed: () {
                  setState(() {
                    selectedAmountFilter = 'below100';
                  });
                },
                isSelected: selectedAmountFilter == 'below100',
              ),
              FilterButton(
                label: '\₹100 - \₹200',
                onPressed: () {
                  setState(() {
                    selectedAmountFilter = '100to200';
                  });
                },
                isSelected: selectedAmountFilter == '100to200',
              ),
              FilterButton(
                  label: '\₹200 - \₹300',
                  onPressed: () {
                    setState(() {
                      selectedAmountFilter = '200to300';
                    });
                  },
                  isSelected: selectedAmountFilter == '200to300'),
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screeHeight / 4,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: LoadingWidget(
                        option: 2,
                      ),
                    ),
                  ],
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
  final bool isSelected;

  const FilterButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isSelected = false, // Add isSelected parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Colors.black
            : Colors.white, // Set primary color based on isSelected
        foregroundColor: isSelected
            ? Colors.white
            : Colors.black, // Set onPrimary color based on isSelected
        side: BorderSide(
          color: isSelected
              ? Colors.black
              : Colors
                  .transparent, // Correctly set border color based on isSelected
          width: 2.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(label),
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
        border: Border.all(color: g),
        color: Color.fromARGB(255, 233, 233, 233),
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
