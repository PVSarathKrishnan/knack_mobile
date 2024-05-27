import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle text_style_h = GoogleFonts.poppins(
  fontWeight: FontWeight.bold,
  fontSize: 30,
);

TextStyle text_style_n = GoogleFonts.poppins(
  fontSize: 15,
);


  TextStyle DateTextStyle() => GoogleFonts.poppins(
    fontSize: 12,fontWeight: FontWeight.w600, color: Colors.grey
  );

  TextStyle TimeTextStyle() {
    return GoogleFonts.poppins(
          fontSize: 10,
        );
  }