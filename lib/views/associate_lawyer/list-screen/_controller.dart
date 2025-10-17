import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:justice/AppData.dart';
import 'package:justice/models/associate_lawyer_model.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/res/navigation_service/GlobalContext.dart';
import 'package:justice/temp_data/cases-data.dart';
import 'package:justice/temp_data/users-data.dart';
import 'package:justice/views/associate_lawyer/add-associate-lawyer/add_associate_dialog.dart';
import '../../../temp_data/associatedCases.dart';

class Controller extends GetxController{
   Future<List<AssociatedLinksModel>> get getCases async {
     final currentUser = await UserModel.currentUser;
     return AssociatedCases().getAssociatedCasesByLawyerId(currentUser.id);
   }

   void showAddLawyerDialog(){
     showDialog(context: GlobalContext.getContext, builder: (context){
       return AddAssociateDialog();
     });
   }
}

