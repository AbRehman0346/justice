import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:justice/temp_data/temp-data.dart';
import 'package:justice/test-screen.dart';
import 'package:justice/views/associate_lawyer/associate_lawyers_screen.dart';
import 'package:justice/views/management_screen/management_screen.dart';
import './views/tabs/tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TempData().init();
    return GetMaterialApp(
      // navigatorKey: GlobalContext.navigatorKey,
      title: 'JUSTICE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Tabs(),
    );
  }
}
