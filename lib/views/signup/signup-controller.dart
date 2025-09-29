import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var selectedUserType = 'Lawyer'.obs;
  var selectedCountry = 'United States'.obs;
  var selectedCity = 'New York'.obs;

  final List<String> userTypes = ['Lawyer', 'Junior Lawyer'];
  final Map<String, List<String>> countriesCities = {
    'United States': ['New York', 'Los Angeles', 'Chicago', 'Houston'],
    'United Kingdom': ['London', 'Manchester', 'Birmingham', 'Liverpool'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal', 'Calgary'],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth'],
  };

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void setUserType(String type) {
    selectedUserType.value = type;
  }

  void setCountry(String country) {
    selectedCountry.value = country;
    selectedCity.value = countriesCities[country]?.first ?? '';
  }

  void setCity(String city) {
    selectedCity.value = city;
  }

  Future<void> signUp() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    isLoading.value = false;

    Fluttertoast.showToast(msg: "Functionality still needs development.");
  }

  void pop(){
    NavigatorService.pop();
  }
}