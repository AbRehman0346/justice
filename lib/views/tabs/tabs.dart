import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/views/calender/calender-view.dart';
import 'package:justice/views/home/home-screen.dart';
import 'tabs-controller.dart' as tabCont;

class Tabs extends StatelessWidget {
  Tabs({super.key});

  final tabCont.TabController controller = Get.put(tabCont.TabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.bgSurface,
      body: Obx(() => body()),
      bottomNavigationBar: _buildAnimatedBottomBar(),
    );
  }


  Widget body(){
    if(controller.activeTab.value == 0){
      return HomeScreen();
    }
    else if(controller.activeTab.value == 1){
      return CalendarScreen();
    }

    return Container();
  }

  Widget? _buildAnimatedBottomBar(){
    return CurvedNavigationBar(
      height: 55,
      backgroundColor: Colors.transparent,
      color: AppColors.bg[0],
      items: [
        Icon(Icons.home, size: 30, color: AppColors.foreground),
        Icon(Icons.calendar_month, size: 30, color: AppColors.foreground),
      ],
      onTap: (index) => controller.changeTab(index),
    );
  }
}
