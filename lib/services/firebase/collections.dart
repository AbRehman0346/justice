import 'package:cloud_firestore/cloud_firestore.dart';
class Collections{
  final _instance = FirebaseFirestore.instance;
  CollectionReference get users => _instance.collection("users");
  CollectionReference get cases => _instance.collection("cases");
}