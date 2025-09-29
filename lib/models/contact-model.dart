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
}

class ContactType{
  String client = "client";
  String employee = "employee";
}