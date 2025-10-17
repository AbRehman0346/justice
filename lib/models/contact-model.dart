import 'dart:developer';

class ContactFields{
  final String id = "id";
  final String email = "email";
  final String contactNumber = "contactNumber";
  final String type = "type";
  final String name = "name";
  final String createdAt = "createdAt";
}

class ContactModel {
  final String id;
  final String? email;
  final String? contactNumber;
  final String type; // client, opposing counsel, judge, etc.
  final String name;
  final DateTime createdAt;

  ContactModel({
    required this.id,
    this.email,
    this.contactNumber,
    required this.type,
    required this.name,
    required this.createdAt,
  });

  void print(){
    log("id: $id");
    log("email: $email");
    log("contactNumber: $contactNumber");
    log("type: $type");
    log("name: $name");
    log("createdAt: $createdAt");
  }

  Map toMap(){
    var f = ContactFields();
    return {
      f.id: id,
      f.email: email,
      f.contactNumber: contactNumber,
      f.type: type,
      f.name: name,
      f.createdAt: createdAt,
    };
  }
}

class ContactType{
  String client = "client";
  String employee = "employee";
}