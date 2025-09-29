import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/res/xwidgets/xtext.dart';
import 'package:justice/temp_data/temp-data.dart';

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
            ElevatedButton(onPressed: addCase, child: XText("Add Case")),
            ElevatedButton(onPressed: printCases, child: XText("Print Cases")),
          ],
        ),
      ), //destination screen

    );
  }

  void printCases(){
    log("==============>  Cases:  ${TempData.cases.length}");
    for(var kase in TempData.cases){
      log("==============> ${kase.title}");
    }
    Fluttertoast.showToast(msg: "Cases ${TempData.cases.length}");
  }

  void addCase() {
    CaseModel newCase = CaseModel(
      id: '1',
      title: 'Smith vs Johnson Property Dispute',
      court: 'Supreme Court',
      city: 'New York',
      caseNumber: 'SC-2024-001',
      date: null,
      clientIds: [
        TempData.contact("John Smith"),
      ],
      status: 'upcoming',
      priority: 'high',
      proceedingsDetails: '',
      caseStage: 'Evidance',
      createdAt: DateTime.now(),
    );

    TempData.cases.add(newCase);
    log("Case Added Successfully");
  }



}
