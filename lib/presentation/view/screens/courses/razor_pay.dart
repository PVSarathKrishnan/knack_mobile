import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:knack/bloc/fetch_bloc/bloc/fetch_course_bloc.dart';
import 'package:knack/presentation/view/screens/bottom_navigation_bar.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:knack/presentation/view/widgets/custom_snackbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayScreen extends StatefulWidget {
  const RazorPayScreen({super.key, required this.courseID});
  final courseID;

  @override
  State<RazorPayScreen> createState() => _RazorPayScreenState();
}

class _RazorPayScreenState extends State<RazorPayScreen> {
  Razorpay? _razorpay;
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, paymentWallet);
    super.initState();
  }

  String? bookID;
  Map<String, dynamic> detail = {};
  //payment methods - success,error, external wallet

  paymentSuccess(PaymentSuccessResponse response) {
    CustomSnackBar(content: "payment success");
    context
        .read<FetchCourseBloc>()
        .add(BookCourseEvent(data: detail, bookingId: bookID!));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BNBPage(),
        ),
        (route) => false);
  }

  paymentError(PaymentFailureResponse response) {
    CustomSnackBar(content: "payment failed");
  }

  paymentWallet(ExternalWalletResponse response) {
    CustomSnackBar(content: "External wallet is  ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<FetchCourseBloc>()
        .add(SpecialCourseLoadEvent(courseID: widget.courseID));
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<FetchCourseBloc, FetchCourseState>(
      builder: (context, state) {
        if (state is SpecialCourseLoadedState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state.specialCourseList[0].title,
                style: text_style_n,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 218, 218, 218),
            body: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(top: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: ClipOval(
                            child: Container(
                              color: Colors.blue,
                              padding: EdgeInsets.all(10.0),
                              child: Image.asset(
                                'lib/assets/razor_pay.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Proceed to RazorPay",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            var options = {
                              'key': 'rzp_test_z1FxyLMrDHTf2F',
                              'amount':
                                  "${(int.parse(state.specialCourseList[0].amount)) * 100}",
                              'name': 'knack',
                              'description': state.specialCourseList[0].title,
                              'prefill':
                                  '${FirebaseAuth.instance.currentUser?.email}'
                            };
                            var dataset = {
                              "user_id": FirebaseAuth.instance.currentUser!.uid,
                              "user_name":
                                  '${FirebaseAuth.instance.currentUser!.displayName}',
                              "course_id": state.specialCourseList[0].courseID,
                              "course_title": state.specialCourseList[0].title,
                              "course_photo": state.specialCourseList[0].photo,
                              "booking_date": DateFormat("dd-MM-yyyy")
                                  .format(DateTime.now()),
                              "booking_amount":
                                  "${int.parse(state.specialCourseList[0].amount)}"
                            };
                            bookCourse(state, dataset, options);
                            // Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: CircularProgressIndicator()),
              IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BNBPage(),
                        ),
                        (route) => false);
                  },
                  icon: const Icon(Icons.arrow_back_ios))
            ],
          )),
        );
      },
    );
  }

  void bookCourse(FetchCourseState state, Map<String, String> dataset,
      Map<String, String> ops) async {
    try {
      print('try 1');
      final courseSnapshot = await FirebaseFirestore.instance
          .collection("courses")
          .doc(dataset["course_id"])
          .get();
      print('try 2');
      Map<String, dynamic> courseData = courseSnapshot.data() ?? {};
      String bookingID =
          FirebaseFirestore.instance.collection("bookings").doc().id;
      print('try 3');
      Map<String, dynamic> details = {
        "booking_id": bookingID,
        "user_id": dataset["user_id"],
        "user_name": dataset["user_name"],
        "date": dataset['booking_date'],
        "course_id": dataset["course_id"],
        "course_photo": dataset["course_photo"],
        "course_title": dataset["course_title"],
        "booking_amount": dataset['booking_amount'],
        "courseDetails": courseData,
      };
      print('try 4');
      var options = {
        "key": "rzp_test_z1FxyLMrDHTf2F",
        "amount": ops["amount"],
        "name": ops["name"],
        "course": ops["courses"],
        "prefill": ops["prefill"]
      };
      bookID = bookingID;
      detail = details;
      _razorpay?.open(options);
      print("complete success");
    } on FirebaseException catch (e) {
      CustomSnackBar(content: e.message.toString());
    }
  }
}
