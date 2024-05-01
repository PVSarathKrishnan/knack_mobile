part of 'fetch_course_bloc.dart';

sealed class FetchCourseState extends Equatable {
  const FetchCourseState();

  @override
  List<Object> get props => [];
}

final class FetchCourseInitial extends FetchCourseState {}

final class FetchCourseLoadingState extends FetchCourseState {}

class FetchCourseLoadedState extends FetchCourseState {
  final List<CourseModel> courseList;

  FetchCourseLoadedState({
    required this.courseList,
  });

  @override
  List<Object> get props => [courseList];
}

class SpecialCourseLoadedState extends FetchCourseState {
  final List<CourseModel> specialCourseList;
  const SpecialCourseLoadedState({required this.specialCourseList});
  @override
  List<Object> get props => [specialCourseList];
}

class SearchLoadedState extends FetchCourseState {
  final List<CourseModel> searchedCourseList;
  const SearchLoadedState({required this.searchedCourseList});
  @override
  List<Object> get props => [searchedCourseList];
}

class MyCoursesErrorState extends FetchCourseState {}

class MyCoursesLoadedState extends FetchCourseState {
  final List<BookingModel> myCourseList;
  // final List<SubscriptionModel> subsList;
  final UserModel userList;

  const MyCoursesLoadedState(
      {required this.myCourseList,
      // required this.subsList,
      required this.userList});
  @override
  List<Object> get props => [myCourseList, userList];
}
