import 'dart:developer';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/AppData.dart';
import 'package:justice/models/date-model.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/temp_data/cases-data.dart';
import '../../models/case-model.dart';
import 'home-controller.dart';

class HomeScreen extends StatelessWidget {
  final Key _scaffoldKey = UniqueKey();
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgSurface,
      body: Column(
        children: [
          // Header Section
          _buildHeader(),

          // Search and Filter Section
          _buildSearchFilterSection(),

          // Cases List
          _buildCasesList(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildAnimatedBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.bg,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.getGreeting(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    UserModel.getCurrentUser.name,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              //TODO: Remember to Remove this Gesture Detector... It's only for test..
              GestureDetector(
                onTap: (){
                  log("==================CURRENT USER=========================>");

                  log(UserModel.getCurrentUser.id);
                  log(UserModel.getCurrentUser.name);
                  log(UserModel.getCurrentUser.email);
                  log(UserModel.getCurrentUser.country);
                  log(UserModel.getCurrentUser.city);
                  log(UserModel.getCurrentUser.phoneNumber);
                  log(UserModel.getCurrentUser.password);

                  log("===========================================>");
                  Fluttertoast.showToast(msg: "Cases ${CasesData.cases.length}");
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF1A365D),
                    size: 30,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Stats Cards
          // _buildStatsCards(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final status = HearingStatus();
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            value: controller.cases.length.toString(),
            label: 'Total Cases',
            icon: Icons.folder_open_rounded,
            color: Color(0xFF48BB78),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            value: controller.cases.where((c) => c.status == status.upcoming).length.toString(),
            label: "Upcoming",
            icon: Icons.calendar_today_rounded,
            color: Color(0xFFED8936),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            value: controller.cases.where((c) => c.priority == CasePriority().high).length.toString(),
            label: 'High Priority',
            icon: Icons.warning_amber_rounded,
            color: Color(0xFFF56565),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
        required String value,
        required String label,
        required IconData icon,
        required Color color
      }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              onChanged: controller.searchCases,
              decoration: InputDecoration(
                hintText: 'Search cases, clients, or case numbers...',
                hintStyle: GoogleFonts.poppins(color: Color(0xFFA0AEC0)),
                prefixIcon: Icon(Icons.search, color: Color(0xFF4A5568)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),

          SizedBox(height: 12),

          // Filter Chips
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: controller.filters.map((filter) {
                return Obx(() => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: GoogleFonts.poppins(
                        color: controller.selectedFilter.value == filter ?
                        Colors.white : Color(0xFF4A5568),
                      ),
                    ),
                    selected: controller.selectedFilter.value == filter,
                    onSelected: (selected) => controller.setFilter(filter),
                    backgroundColor: Colors.white,
                    selectedColor: Color(0xFF1A365D),
                    checkmarkColor: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCasesList() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.filteredCases.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshCases(),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.filteredCases.length + 1,
            itemBuilder: (context, index) {
              if(index == controller.filteredCases.length){
                return XUtils.height(80);
              }
              final caseItem = controller.filteredCases[index];
              return _buildCaseCard(caseItem);
            },
          ),
        );
      }),
    );
  }

  Widget _buildCaseCard(CaseModel caseItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            log("===========title: ${caseItem.title}");
            controller.gotoDetailScreen(caseItem);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Case Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        caseItem.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A365D),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildPriorityIndicator(caseItem.priority),
                  ],
                ),

                SizedBox(height: 12),

                // Case Details
                _buildCaseDetailRow(
                  icon: Icons.assignment_rounded,
                  text: caseItem.caseNumber ?? "",
                ),

                _buildCaseDetailRow(
                  icon: Icons.person_rounded,
                  text: caseItem.clientIds == null ? "No Client Added" :
                    caseItem.clientIds!.isEmpty ? "No Client Added" :
                        caseItem.clientIds!.first.name
                  ,
                ),

                _buildCaseDetailRow(
                  icon: Icons.account_balance_rounded,
                  text: '${caseItem.court}, ${caseItem.city}',
                ),

                SizedBox(height: 8),

                // Date Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateChip(
                      label: 'Previous',
                      date: caseItem.date?.lastDate?.date,
                      color: Color(0xFFCBD5E0),
                    ),
                    _buildDateChip(
                      label: 'Next Hearing',
                      date: caseItem.date?.upcomingDate,
                      color: _getNextDateColor(caseItem.date?.upcomingDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    final color = priority == 'high' ? Color(0xFFF56565) :
    priority == 'medium' ? Color(0xFFED8936) : Color(0xFF48BB78);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        priority.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCaseDetailRow({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Color(0xFF718096)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip({
    required String label,
    DateTime? date,
    required Color color
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            date == null ? "" :
            controller.formatDate(date),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getNextDateColor(DateTime? nextDate) {
    if(nextDate == null){
      return Color(0xFF48BB78);
    }

    final daysDifference = nextDate.difference(DateTime.now()).inDays;
    if (daysDifference <= 2) return Color(0xFFF56565); // Red for urgent
    if (daysDifference <= 7) return Color(0xFFED8936); // Orange for soon
    return Color(0xFF48BB78); // Green for normal
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 80,
            color: Color(0xFFCBD5E0),
          ),
          SizedBox(height: 5),
          Text(
            'No cases found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          Text(
            'Try changing your filters or search terms',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: FloatingActionButton(
        onPressed: controller.gotoAddCase,
        backgroundColor: Color(0xFF1A365D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget? _buildAnimatedBottomBar(){
    return null;
    return CurvedNavigationBar(
      height: 55,
      backgroundColor: AppColors.bgSurface,
      items: <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.calendar_month, size: 30),
      ],
      onTap: (index) => controller.changeTab(index),
    );
  }
}