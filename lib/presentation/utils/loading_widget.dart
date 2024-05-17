import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final int option;

  const LoadingWidget({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    String assetPath;
    switch (option) {
      case 1:
        assetPath = "lib/assets/loader_b.json";
        break;
      case 2:
        assetPath = "lib/assets/loader_g.json";

        break;
      default:
        assetPath = "lib/assets/loading_b.json";
        break;
    }
    return Lottie.asset(assetPath,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high);
  }
}
