import 'package:flutter/material.dart';
import 'package:knack/view/style/text_style.dart';
import 'package:lottie/lottie.dart';

Container UCWidget = Container(
  height: 400,
  width: 400,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset("lib/assets/uc.json", height: 150, width: 150),
      Text(
        "This page is under development",
        style: text_style_h.copyWith(fontSize: 15),
      )
    ],
  ),
);
