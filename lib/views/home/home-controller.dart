import 'dart:developer';
import 'package:get/get.dart';
import 'package:justice/models/contact-model.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/temp_data/cases-data.dart';
import '../../models/case-model.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs;
  var currentDate = DateTime.now().obs;
  RxInt tabIndex = 1.obs;

  final List<String> filters = ['All', 'Today', 'Upcoming', 'Disposed Off', 'High Priority'];

  List<CaseModel> cases = CasesData.cases;

  List<CaseModel> get filteredCases {
    var caseStatus = CaseStatus();
    var dateTime = DateTime.now();
    var filtered = cases.where((CaseModel caseItem) {
      final matchesSearch = caseItem.title.toLowerCase().contains(searchQuery.toLowerCase());
      if(selectedFilter.value == filters[0]){
        // All Filter -> It shows all the active cases..
        return caseItem.status == caseStatus.active;
      }

      bool matchesFilter = true;

      if(selectedFilter.value == filters[1]){
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
      } else if(selectedFilter.value == filters[4]){
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
  }

  void searchCases(String query) {
    searchQuery.value = query;
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

  void refreshCases() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    cases = CasesData.cases;
    isLoading.value = false;
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