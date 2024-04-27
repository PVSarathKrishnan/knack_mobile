part of 'fetch_course_bloc.dart';

sealed class FetchCourseState extends Equatable {
  const FetchCourseState();

  @override
  List<Object> get props => [];
}

final class FetchCourseInitial extends FetchCourseState {}

class FetchCourseLoadedState extends FetchCourseState {
  final List<CourseModel> courseList;

  FetchCourseLoadedState({
    required this.courseList,
  });

  @override
  List<Object> get props => [courseList];
}
