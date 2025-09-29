import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/temp_data/temp-data.dart';

class LinkCaseController extends GetxController{
    TextEditingController txtController = TextEditingController();
    FocusNode focusNode = FocusNode();
    RxList<CaseModel> cases = TempData.cases.obs;
    RxList<CaseModel> linkedCases = <CaseModel> [].obs;

    void onSelected(var value){
      txtController.text = "";
      if(linkedCases.contains(value)){
        Get.snackbar("Link Case", "Case Already Present");
        return;
      }
      linkedCases.add(value);
    }

    void removeLinkedCase(CaseModel kase) {
      linkedCases.remove(kase);
    }

    List<String> get getLinkedCasesIds => linkedCases.map((value) => value.title).toList();

    CaseModel getCaseFromId(String id){
      return TempData.cases.firstWhere((value) => value.id == id);
    }

    void loadCaseFromLinkedIds(List<String> ids){
      for(String id in ids){
        linkedCases.add(getCaseFromId(id));
      }
    }
}