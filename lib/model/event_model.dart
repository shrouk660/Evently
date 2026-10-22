import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
   String? id;
   String? userId;
   String? title;
   String? description;
   String? category;
   Timestamp? dateAndTime;


  EventModel({
     this.id,
     this.userId,
     this.title,
     this.description,
     this.category,
     this.dateAndTime,
  });
  EventModel.fromFireStore(Map<String,dynamic>? data){
    id = data?["id"];
    userId = data?["userId"];
    title = data?["title"];
    description = data?["description"];
    category = data?["category"];
    dateAndTime = data?["dateAndTime"];
  }
  Map <String,dynamic> toFirStore(){
    return{
      "id" : id,
      "userId" : userId,
      "title" : title,
      "description" : description,
      "category" : category,
      "dateAndTime" : dateAndTime,
    };
  }
}