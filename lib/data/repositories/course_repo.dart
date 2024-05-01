import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:knack/data/models/booking_model.dart';
import 'package:knack/data/models/course_model.dart';

class CourseRepo {
  Future<List<CourseModel>> getCourses() async {
    List<CourseModel> courseList = [];

    try {
      print('course repo try  1');
      final dataset =
          await FirebaseFirestore.instance.collection("courses").get();
      dataset.docs.forEach((element) {
        final data = element.data();
        print('course repo try  2');
        final course = CourseModel(
            courseID: data["courseID"],
            photo: data["photo"],
            title: data["title"],
            overview: data["overview"],
            chapters: data["chapters"],
            description: data["description"],
            amount: data["amount"],
            document: data["document"],
            videos: data["videos"]);
        print('course repo try  3');
        courseList.add(course);
        print('course repo try  4');
        print(course);
      });
      return courseList;
    } on FirebaseException catch (e) {
      debugPrint("exception on fetching courses :${e.message}");
    }
    return courseList;
  }
//specific courses fetch

  Future<List<CourseModel>> getSpecialCourses(String courseID) async {
    List<CourseModel> specialCourseList = [];
    try {
      final dataset = await FirebaseFirestore.instance
          .collection("courses")
          .where("courseID", isEqualTo: courseID)
          .get();

      for (var element in dataset.docs) {
        final data = element.data();
        final specialCourses = CourseModel(
            courseID: data["courseID"],
            photo: data["photo"],
            title: data["title"],
            overview: data["overview"],
            chapters: data["chapters"],
            description: data["description"],
            amount: data["amount"],
            document: data["document"],
            videos: data["videos"]);

        specialCourseList.add(specialCourses);
      }
      return specialCourseList;
    } on FirebaseException catch (e) {
      debugPrint("expection getting specific subscritpions. : ${e.message}");
    }
    return specialCourseList;
  }

  Future<List<CourseModel>> searchCourses(String keyword) async {
    List<CourseModel> searchedCoursesList = [];
    try {
      final dataset = await FirebaseFirestore.instance
          .collection("courses")
          .where('title', isNotEqualTo: keyword)
          .orderBy('title')
          .startAt([keyword]).get();

      for (var element in dataset.docs) {
        final data = element.data();
        final searchedCourses = CourseModel(
            courseID: data["courseID"],
            photo: data["photo"],
            title: data["title"],
            overview: data["overview"],
            chapters: data["chapters"],
            description: data["description"],
            amount: data["amount"],
            document: data["document"],
            videos: data["videos"]);

        searchedCoursesList.add(searchedCourses);
      }
      return searchedCoursesList;
    } on FirebaseException catch (e) {
      debugPrint("expection getting specific Courses. : ${e.message}");
    }
    return searchedCoursesList;
  }

  //user's courses

  Future<List<BookingModel>> myCourses(String uid) async {
    List<BookingModel> myCourseList = [];
    try {
      final dataset = await FirebaseFirestore.instance
          .collection("bookings")
          .where('user_id', isEqualTo: uid)
          .get();

      for (var element in dataset.docs) {
        final data = element.data();
        final myCourses = BookingModel(
          course_id: data['course_id'],
          course_title: data['course_title'],
          course_photo: data['course_photo'],
          booking_amount: data['booking_amount'],
          booking_id: data['booking_id'],
          date: data['date'].toString(),
          user_id: data['user_id'],
          courseDetails: data['courseDetails'],
        );

        myCourseList.add(myCourses);
      }
    } on FirebaseException catch (e) {
      debugPrint("expection getting my subscritpions. : ${e.message}");
    }
    return myCourseList;
  }

  //course history

  Future<List<BookingModel>> myCourseHistory(String uid) async {
    List<BookingModel> historylist = [];
    try {
      final dataset = await FirebaseFirestore.instance
          .collection("bookings")
          .where('user_id', isEqualTo: uid)
          .orderBy('date')
          .get();
      for (var element in dataset.docs) {
        final data = element.data();
        final myCourses = BookingModel(
          course_id: data['course_id'],
          course_title: data['course_title'],
          course_photo: data['course_photo'],
          booking_amount: data['booking_amount'],
          booking_id: data['booking_id'],
          date: data['date'].toString(),
          user_id: data['user_id'],
          courseDetails: data['courseDetails'],
        );

        historylist.add(myCourses);
      }
      return historylist;
    } on FirebaseException catch (e) {
      debugPrint("expection getting my subscritpions. : ${e.message}");
    }
    return historylist;
  }
}
