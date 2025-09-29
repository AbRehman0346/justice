import 'package:get/get.dart';

class TabController extends GetxController{
  RxInt activeTab = 0.obs;




  void changeTab(index){
    activeTab.value = index;
  }
}