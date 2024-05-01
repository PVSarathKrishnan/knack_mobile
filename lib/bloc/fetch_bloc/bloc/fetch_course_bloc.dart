import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:knack/data/models/booking_model.dart';
import 'package:knack/data/models/course_model.dart';
import 'package:knack/data/models/user_model.dart';
import 'package:knack/data/repositories/course_repo.dart';

part 'fetch_course_event.dart';
part 'fetch_course_state.dart';

class FetchCourseBloc extends Bloc<FetchCourseEvent, FetchCourseState> {
  CourseRepo courseRepo = CourseRepo();
  FetchCourseBloc(this.courseRepo) : super(FetchCourseInitial()) {
    on<FetchCourseLoadedEvent>(getCoursesfunction);
    on<SpecialCourseLoadEvent>(getSpecialCourses);
    on<SearchCourseEvent>(searchCourses);
    on<BookCourseEvent>(bookCourses);
    on<MyCoursesLoadEvent>(myCourses);
  }

  FutureOr<void> getCoursesfunction(
      FetchCourseEvent event, Emitter<FetchCourseState> emit) async {
    emit(FetchCourseInitial());
    print("loading...................");
    final courses = await courseRepo.getCourses();
    print(courses);
    print("after loading");
    if (courses.isEmpty) {
      emit(FetchCourseInitial());
      print("empty");
    }
    emit(FetchCourseLoadedState(courseList: courses));
    print("loaded");
  }

  FutureOr<void> getSpecialCourses(
      SpecialCourseLoadEvent event, Emitter<FetchCourseState> emit) async {
    final specCourses = await courseRepo.getSpecialCourses(event.courseID);
    emit(SpecialCourseLoadedState(specialCourseList: specCourses));
  }

  FutureOr<void> searchCourses(
      SearchCourseEvent event, Emitter<FetchCourseState> emit) async {
    try {
      if (event.searchWord.isNotEmpty) {
        final searchedCourses =
            await courseRepo.searchCourses(event.searchWord);
        emit(SearchLoadedState(searchedCourseList: searchedCourses));
      } else {
        final courseList = await courseRepo.getCourses();
        emit(FetchCourseLoadedState(courseList: courseList));
      }
    } catch (e) {
      debugPrint("searchSubs${e.toString()}");
    }
  }

  FutureOr<void> bookCourses(
      BookCourseEvent event, Emitter<FetchCourseState> emit) async {
    try {
      await FirebaseFirestore.instance
          .collection("bookings")
          .doc(event.bookingId)
          .set(event.data)
          .then((value) {
        debugPrint("booking successful");
      });
    }  on FirebaseException catch(e){
      debugPrint("bookingSubs ${e.message}");
    }
  }

  FutureOr<void> myCourses(
      MyCoursesLoadEvent event, Emitter<FetchCourseState> emit) async {
        
      }
}
