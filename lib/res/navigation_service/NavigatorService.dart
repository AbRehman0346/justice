import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/models/contact-model.dart';
import 'package:justice/res/navigation_service/routes.dart';
import 'package:justice/views/case_details/case-details-screen.dart';
import 'package:justice/views/contact/add-contact-screen.dart';
import 'package:justice/views/create_case/add-case.dart';
import 'package:justice/views/edit_case/case-edit.dart';
import 'package:justice/views/signin/signin.dart';
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

  Future<void> gotoCaseDetails({
    bool rmStack = false,
    required CaseModel kase,
  }) async {
    Widget view = CaseDetailsScreen(kase: kase);
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