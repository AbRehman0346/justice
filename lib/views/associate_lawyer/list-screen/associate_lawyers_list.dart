import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/models/associate_lawyer_model.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import '_controller.dart';

class AssociateLawyersScreen extends StatelessWidget {

  late final Controller controller;

  _init(){
    controller = Get.put(Controller());
  }

  @override
  Widget build(BuildContext context) {
    _init();

    final associatedCases = controller.getCases;

    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      appBar: AppBar(
        title: Text('Associate Lawyers', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1A365D)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Color(0xFF1A365D)),
            onPressed: () {
              Get.snackbar(
                'Add Associate',
                'Add new associate lawyer functionality',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: associatedCases.length,
        itemBuilder: (context, index) {
          return _buildAssociateCard(associatedCases[index]);
        },
      ),
    );
  }

  Widget _buildAssociateCard(AssociateLawyerModel kase) {

    final associate = controller.getLawyersById(kase.associateLawyerId);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Color(0xFF1A365D).withOpacity(0.1),
          child: Icon(Icons.person, color: Color(0xFF1A365D)),
        ),
        title: Text(
          associate.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(associate.email),
            SizedBox(height: 4),
            Text(
              kase.caseAccesses.length.toString(),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Color(0xFF48BB78),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFCBD5E0)),
        onTap: () {
          NavigatorService().gotoAssociateLawyerDetail();
        },
      ),
    );
  }
}