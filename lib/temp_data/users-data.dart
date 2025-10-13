import 'dart:developer';
import 'package:justice/models/user-model.dart';

class UsersData {
  static List<UserModel> users = [
    UserModel(
      id: "1",
      name: 'Ali Khan',
      phoneNumber: '+923001112233',
      email: 'ali.khan@example.com',
      assignedNumber: 'A-101',
      country: 'Pakistan',
      city: 'Karachi',
      password: 'Ali@12345',
    ),
    UserModel(
      id: "2",
      name: 'Sara Ahmed',
      phoneNumber: '+923112223344',
      email: 'sara.ahmed@example.com',
      assignedNumber: 'A-102',
      country: 'Pakistan',
      city: 'Lahore',
      password: 'Sara@12345',
    ),
    UserModel(
      id: "3",
      name: 'John Doe',
      phoneNumber: '+971500112233',
      email: 'john.doe@example.com',
      assignedNumber: 'UAE-201',
      country: 'UAE',
      city: 'Dubai',
      password: 'John@12345',
    ),
    UserModel(
      id: "4",
      name: 'Fatima Zahra',
      phoneNumber: '+923222334455',
      email: 'fatima.zahra@example.com',
      assignedNumber: null, // optional
      country: 'Pakistan',
      city: 'Islamabad',
      password: 'Fatima@12345',
    ),
    UserModel(
      id: "5",
      name: 'Michael Smith',
      phoneNumber: '+441234567890',
      email: 'michael.smith@example.com',
      assignedNumber: 'UK-009',
      country: 'UK',
      city: 'London',
      password: 'Mike@12345',
    ),
    UserModel(
      id: "6",
      name: 'Abdul Rehman',
      phoneNumber: '+923033372287',
      email: 'ar@gmail.com',
      assignedNumber: 'A-103',
      country: 'Pakistan',
      city: 'Karachi',
      password: '8942392',
    ),
  ];

  UserModel? getUserByEmailAndPassword(String email, String password){
    for (UserModel user in users) {
      if (user.email == email && user.password == password) {
        return user;
      }
    }
    return null;
  }

  UserModel? getUserById(String id){
    for (UserModel user in users) {
      if (user.id == id) {
        return user;
      }
    }
    return null;
  }

  UserModel? findUserByEmailOrPhone(String emailOrPhone) {
    try{
      return UsersData.users.firstWhere(
            (user) =>
        user.email?.toLowerCase() == emailOrPhone.toLowerCase() ||
            user.phoneNumber?.replaceAll(RegExp(r'[^0-9]'), '') == emailOrPhone.replaceAll(RegExp(r'[^0-9]'), ''),
      );
    }catch(e){
      return null;
    }
  }
}
