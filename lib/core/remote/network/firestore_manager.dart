import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreManager {

  static saveUser(){
    var collection =FirebaseFirestore.instance.collection("User");
    var doc = collection;


  }
}