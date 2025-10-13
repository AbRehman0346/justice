import 'package:get/get.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/temp_data/users-data.dart';
import '../../../models/associate_lawyer_model.dart';
import '../../../models/user-model.dart';

class AddAssociateController extends GetxController {
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedRole = LawyerRole().partner.capitalizeFirst!.obs;
  var foundUser = Rxn<UserModel>();
  var searchError = ''.obs;
  String _uniqueId = XUtils().getUniqueId();

  void setRole(String role) {
    selectedRole.value = role;
  }

  List<String> get roleOptions => LawyerRole().all;

  void searchUser() {
    if (searchQuery.value.isEmpty) {
      searchError.value = 'Please enter email or phone number';
      foundUser.value = null;
      return;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

    if (!emailRegex.hasMatch(searchQuery.value) && !phoneRegex.hasMatch(searchQuery.value)) {
      searchError.value = 'Please enter a valid email or phone number';
      foundUser.value = null;
      return;
    }

    searchError.value = '';
    isLoading.value = true;

    // Simulate API call delay
    Future.delayed(Duration(seconds: 1), () {
      final user = UsersData().findUserByEmailOrPhone(searchQuery.value);
      foundUser.value = user?.id.isNotEmpty == true ? user : null;

      if (foundUser.value == null) {
        searchError.value = 'No lawyer found with this email or phone number';
      }

      isLoading.value = false;
    });
  }

  void clearSearch() {
    searchQuery.value = '';
    foundUser.value = null;
    searchError.value = '';
  }

  AssociatedLinksModel createAssociatedLink() {
    return AssociatedLinksModel(
      id: _uniqueId,
      lawyerId: UserModel.currentUser.id,
      associateLawyerId: foundUser.value!.id,
      role: selectedRole.value,
      joinedDate: DateTime.now(),
      caseAccesses: [],
    );
  }

  bool get canAddAssociate {
    return foundUser.value != null && searchError.value.isEmpty;
  }
}