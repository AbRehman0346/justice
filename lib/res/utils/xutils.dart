import 'dart:developer';

import 'package:flutter/material.dart';
import '../navigation_service/GlobalContext.dart';
import '../xwidgets/xtext.dart';

class XUtils{
  static Widget height(double height) {
    return SizedBox(height: height);
  }

  static Widget width(double width) {
    return SizedBox(width: width);
  }

  static double get screenHeight =>
      MediaQuery.of(GlobalContext.getContext).size.height;

  static double get screenBodyHeight =>
      MediaQuery.of(GlobalContext.getContext).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(GlobalContext.getContext).padding.top -
          MediaQuery.of(GlobalContext.getContext).padding.bottom;

  static double get screenWidth =>
      MediaQuery.of(GlobalContext.getContext).size.width;

  static void showProgressBar([String? msg]) {
    showDialog(
      barrierDismissible: false,
      context: GlobalContext.getContext,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            if (msg != null) const SizedBox(height: 20),
            if (msg != null)
              XText(msg, bold: true, size: 15, color: Colors.white),
          ],
        ),
      ),
    );
  }

  static void hideProgressBar() {
    Navigator.pop(GlobalContext.getContext);
  }

  void printSuppressedError(Object e, String file){
    log("-------------------------------Error----------------------------------------------");
    log(e.toString());
    log("File: $file");
    log("----------------------------------------------------------------------------------");
  }
}