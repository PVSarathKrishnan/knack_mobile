import 'package:flutter/material.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/style/text_style.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({Key? key, required String content, int duration = 600})
      : super(
          duration: Duration(milliseconds: duration),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          key: key,
          content: Text(
            content,
            style: text_style_h.copyWith(fontSize: 16, color: Colors.black),
          ),
          backgroundColor: g, // Set background color to green
        );
}
