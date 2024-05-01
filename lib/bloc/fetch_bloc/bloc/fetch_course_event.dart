// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'fetch_course_bloc.dart';

sealed class FetchCourseEvent extends Equatable {
  const FetchCourseEvent();

  @override
  List<Object> get props => [];
}

class FetchCourseLoadedEvent extends FetchCourseEvent {}

class SpecialCourseLoadEvent extends FetchCourseEvent {
  String courseID;
  SpecialCourseLoadEvent({
    required this.courseID,
  });

  @override
  List<Object> get props => [courseID];
}

class SearchCourseEvent extends FetchCourseEvent {
  String searchWord;
  SearchCourseEvent({required this.searchWord});
  @override
  List<Object> get props => [searchWord];
}

class BookCourseEvent extends FetchCourseEvent {
  Map<String, dynamic> data = {};
  String bookingId;
  BookCourseEvent({required this.data, required this.bookingId});
}

class MyCoursesLoadEvent extends FetchCourseEvent {
  String uid;
  MyCoursesLoadEvent({
    required this.uid,
  });
}
