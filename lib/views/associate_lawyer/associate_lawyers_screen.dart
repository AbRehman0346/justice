import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AssociateLawyersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildAssociateCard(index);
        },
      ),
    );
  }

  Widget _buildAssociateCard(int index) {
    final associates = [
      {'name': 'Sarah Johnson', 'email': 'sarah@lawfirm.com', 'cases': '12 Active Cases'},
      {'name': 'Michael Chen', 'email': 'michael@lawfirm.com', 'cases': '8 Active Cases'},
      {'name': 'Emily Davis', 'email': 'emily@lawfirm.com', 'cases': '15 Active Cases'},
      {'name': 'Robert Wilson', 'email': 'robert@lawfirm.com', 'cases': '6 Active Cases'},
      {'name': 'Lisa Martinez', 'email': 'lisa@lawfirm.com', 'cases': '10 Active Cases'},
    ];

    final associate = associates[index];

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
          associate['name']!,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(associate['email']!),
            SizedBox(height: 4),
            Text(
              associate['cases']!,
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
          Get.snackbar(
            'Associate Details',
            'Viewing ${associate['name']} details',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
    );
  }
}