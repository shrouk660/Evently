import 'package:evently/core/remote/network/firestore_manager.dart';
import 'package:evently/model/users.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  Users? user;
  setUserValue()async{
    user = await FirestoreManager.getUser();
    notifyListeners();
  }
}