import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/models/associate_lawyer_model.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import '_controller.dart';

class AssociateListScreen extends StatelessWidget {

  late Controller controller;

  _init(){
    controller = Get.put(Controller());
  }

  @override
  Widget build(BuildContext context) {
    _init();

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
            onPressed: () => controller.showAddLawyerDialog(),
          ),
        ],
      ),
      body: FutureBuilder(future: controller.getCases, builder: (context, AsyncSnapshot snap){
        if(!snap.hasData){
          return Center(child: CircularProgressIndicator());
        }

        if(snap.hasError){
          return Center(child: Text(snap.error.toString()));
        }

        List<AssociatedLinksModel> associatedCases = snap.data;


        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: associatedCases.length,
          itemBuilder: (context, index) {
            return _buildAssociateCard(associatedCases[index]);
          },
        );
      }),
    );
  }

  Widget _buildAssociateCard(AssociatedLinksModel associate) {
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
          associate.associateLawyerDetails.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(associate.associateLawyerDetails.email),
            SizedBox(height: 4),
            Text(
              "Shared ${associate.caseAccesses.length.toString()} Cases",
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
          NavigatorService().gotoAssociateLawyerDetail(associate: associate);
        },
      ),
    );
  }
}