import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:justice/AppData.dart';
import 'package:justice/models/associate_lawyer_model.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/temp_data/users-data.dart';

import '../../../temp_data/associatedCases.dart';

class Controller extends GetxController{
   List<AssociateLawyerModel> get getCases {
     return AssociatedCases().getAssociatedCasesByLawyerId(UserModel.getCurrentUser.id);
   }

   UserModel getLawyersById(String id){
      return UsersData().getUserById(id) ?? UserModel.dummy();
   }

}