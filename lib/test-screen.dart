import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/res/extensions/datetime-extensions.dart';
import 'package:justice/res/xwidgets/xtext.dart';
import 'package:justice/temp_data/cases-data.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  List<IconData> iconList = [
    Icons.home,
    Icons.add,
    Icons.settings,
    Icons.calendar_month
  ];

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: onPressed, child: XText("Run Test")),
          ],
        ),
      ), //destination screen

    );
  }

  void onPressed(){
    log("No Any Test ---------------------------------------------------------------");
  }



}
