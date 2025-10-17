import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justice/models/contact-model.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/services/firebase/case/firestore-case.dart';
import 'package:justice/temp_data/cases-data.dart';
import '../../models/case-model.dart';

class HomeController extends GetxController {
  Rx<Key> dataKey = UniqueKey().obs;
  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs;
  var currentDate = DateTime.now().obs;
  RxInt tabIndex = 1.obs;

  final List<String> filters = ['All', 'Today', 'Upcoming', 'Disposed Off', 'High Priority'];

  Future<List<CaseModel>> get _cases async => await FirestoreCase().getCases();


  Future<List<CaseModel>> get filteredCases async {
    var caseStatus = CaseStatus();
    var dateTime = DateTime.now();
    var cases = await _cases;
    var filtered = cases.where((CaseModel caseItem) {
      final matchesSearch = caseItem.title.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesFilter = true;

      if(selectedFilter.value == filters[0]){
        // All Filter ==> Selects all the active cases only..
        matchesFilter = caseItem.status == caseStatus.active;
      }
      else if(selectedFilter.value == filters[1]){
        // Today Filter
        if(caseItem.date != null && caseItem.date!.upcomingDate != null){
          matchesFilter = caseItem.date!.upcomingDate!.day == dateTime.day &&
                caseItem.date!.upcomingDate!.month == dateTime.month &&
                caseItem.date!.upcomingDate!.year == dateTime.year;
        }else{
          matchesFilter = false;
        }
      }
      else if(selectedFilter.value == filters[2]){
        // Upcoming Filter
        if(caseItem.date != null && caseItem.date!.upcomingDate != null) {
          matchesFilter = caseItem.date!.upcomingDate!.day <= dateTime.day &&
              caseItem.date!.upcomingDate!.month <= dateTime.month &&
              caseItem.date!.upcomingDate!.year <= dateTime.year;
        }else{
          matchesFilter = false;
        }
      } else if(selectedFilter.value == filters[3]){
        // Completed Filter
        matchesFilter = caseItem.status == caseStatus.disposeOff;
      }
      else if(selectedFilter.value == filters[4]){
        // High Priority...
        matchesFilter = caseItem.priority == CasePriority().high && caseItem.status == caseStatus.active;
      }
      return matchesSearch && matchesFilter;
    }).toList();

    // // Sort by next date
    filtered.sort((a, b) {
      if(a.date == null || b.date == null){
        return 1;
      }
      if(a.date!.upcomingDate == null || b.date!.upcomingDate == null){
        return 1;
      }

      return a.date!.upcomingDate!.compareTo(b.date!.upcomingDate!);
    });
    return filtered;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    refreshCases();
  }

  void searchCases(String query) {
    searchQuery.value = query;
    refreshCases();
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<void> refreshCases() async {
    dataKey.update((key) => dataKey.value = UniqueKey());
  }

  void gotoAddCase(){
    NavigatorService().gotoAddCase();
  }

  void gotoDetailScreen(CaseModel kase){
    NavigatorService().gotoCaseDetails(kase: kase);
  }

  void changeTab(int index){
    tabIndex.value = index;
  }
}