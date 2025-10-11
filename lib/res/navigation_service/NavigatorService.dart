import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:justice/views/case_screens/hearing_detail/hearing-detail-screen.dart';
import '../../models/case-model.dart';
import '../../models/contact-model.dart';
import '../../models/date-model.dart';
import '../../res/navigation_service/routes.dart';
import '../../views/case_screens/case_details/case-details-screen.dart';
import '../../views/contact/add-contact-screen.dart';
import '../../views/case_screens/create_case/add-case.dart';
import '../../views/case_screens/edit_case/case-edit.dart';
import '../../views/case_screens/edit_case/edit_dates/edit-dates.dart';
import '../../views/signin/signin.dart';
import 'package:justice/views/signup/singup.dart';
import 'GlobalContext.dart';

class NavigatorService{
  Future<dynamic> goto(_GotoModel item) async {
    dynamic result;
    if(item.rmStack) {
      result = await pushAndRemoveUntil(item.view);
    }else{
      result = await push(item.view);
    }
    return result;
  }


  Future<dynamic> push(Widget view) async {
    return await Navigator.push(GlobalContext.getContext, MaterialPageRoute(builder: (context) => view));
  }

  Future<dynamic> pushAndRemoveUntil(Widget view) async {
    return await Navigator.pushAndRemoveUntil(GlobalContext.getContext, MaterialPageRoute(builder: (context) => view), (route)=>false);
  }
  static Future<void> pop() async {
    // if(await _handleIfUserIsBlocked()){
    //   return;
    // }
    Navigator.pop(GlobalContext.getContext);
  }


  // Goto Screens
  Future<void> gotoSignup({
    bool rmStack = false,
  }) async {
    Widget view = SignupScreen();

    final model = _GotoModel(view, rmStack);
    goto(model);
  }

  Future<void> gotoSignIn({
    bool rmStack = false,
  }) async {
    Widget view = SigninScreen();
    goto(_GotoModel(view, rmStack));
  }

  // Case Screens
  Future<void> gotoAddCase({
    bool rmStack = false,
  }) async {
    Widget view = AddCaseScreen();
    goto(_GotoModel(view, rmStack));
  }

  Future<void> gotoCaseEditScreen({
    bool rmStack = false,
    required CaseModel kase,
  }) async {
    Widget view = CaseEditScreen(kase: kase);
    goto(_GotoModel(view, rmStack));
  }

  Future<CaseHearingsDateModel> gotoCaseEditDate({
    bool rmStack = false,
    CaseHearingsDateModel? date,
  }) async {
    Widget view = DateEditScreen(dateModel: date);
    CaseHearingsDateModel newDate = await goto(_GotoModel(view, rmStack));
    return newDate;
  }

  Future<void> gotoCaseDetails({
    bool rmStack = false,
    required CaseModel kase,
  }) async {
    Widget view = CaseDetailsScreen(kase: kase);
    goto(_GotoModel(view, rmStack));
  }

  Future<void> gotoCaseHearingDetails({
    bool rmStack = false,
    required CaseModel kase,
  }) async {
    Widget view = CaseHearingsScreen(kase: kase);
    goto(_GotoModel(view, rmStack));
  }

  // Contact Screens
  Future<ContactModel?> gotoAddContact({
    bool rmStack = false,
  }) async {
    Widget view = AddContactScreen();
    dynamic result = await goto(_GotoModel(view, rmStack));
    return result as ContactModel;
  }
}

class _GotoModel{
  Widget view;
  bool rmStack;
  _GotoModel(this.view, this.rmStack);
}