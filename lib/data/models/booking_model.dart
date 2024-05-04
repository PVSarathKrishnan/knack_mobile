class BookingModel {
  String course_id;
  String course_title;
  String course_photo;
  String booking_amount;
  String booking_id;
  String date;
  String user_id;
  Map<String, dynamic> courseDetails;

  BookingModel(
      {required this.course_id,
      required this.course_title,
      required this.course_photo,
      required this.booking_amount,
      required this.booking_id,
      required this.date,
      required this.user_id,
      required this.courseDetails});
}
