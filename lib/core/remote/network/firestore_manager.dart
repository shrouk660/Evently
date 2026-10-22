import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/model/event_model.dart';
import 'package:evently/model/users.dart';
import 'package:firebase_auth/firebase_auth.dart'as auth;

class FirestoreManager {

  static CollectionReference<Users> getUserCollection(){
    var collection =FirebaseFirestore.instance.collection("User").
    withConverter(
      fromFirestore: (snapshot, options) {
         Map<String,dynamic>? data = snapshot.data();
        return Users.fromFireStore(data);
      },
      toFirestore: (Users, options) {
        return Users.toFirStore();
      },
    );
    return collection;

  }
  static Future<void> saveUser(Users myUser){
    var collection = getUserCollection();
    var doc = collection.doc(myUser.id );
    return doc.set(myUser);


  }
  static Future<Users?> getUser()async{
    var collection = getUserCollection();
    var doc = collection.doc(auth.FirebaseAuth.instance.currentUser?.uid);
    var snapshot = await doc.get();
    return snapshot.data();
 }
  static CollectionReference<EventModel>getEventsCollection(){
   var collection =FirebaseFirestore.instance.collection("Event").
   withConverter(
     fromFirestore: (snapshot, options) {
       var docSnapshot = snapshot.data();
       return EventModel.fromFireStore(docSnapshot);
     },
     toFirestore: (value, options) {
       return value.toFirStore();
     },
   );
   return collection;

 }
  static Future<void>saveEvent(EventModel event){
    var collection = getEventsCollection();
    var doc = collection.doc();
    event.id = doc.id;
    return doc.set(event);
 }
  static Future<List<EventModel>> getAllEvents()async{
    var collection = getEventsCollection();
    var  queryDocSnapshot= await collection.get();
    var docs = queryDocSnapshot.docs;
    List<EventModel> events = docs.map((document) => document.data()).toList();
    return events;
  }
  static Future<void>deletEvent(EventModel event)async{
    var collection = getEventsCollection();
    var doc = collection.doc(event.id);
    await doc.delete();
  }
  static Future<List<EventModel>> getEventsByCategory(String category)async{
    var collection = getEventsCollection();
    var  queryDocSnapshot= await collection.
    where('category',isEqualTo: category).get();
    var docs = queryDocSnapshot.docs;
    List<EventModel> events = docs.map((document) => document.data()).toList();
    return events;

  }
  static Future<void> updateEvent(EventModel event) async {
    var collection = getEventsCollection();
    await collection.doc(event.id).set(event);
  }
  static Stream<List<EventModel>> listenAllEvents()async*{
    var collection = getEventsCollection();
    var  queryDocSnapshotStream = collection.snapshots();
    var docsStream = queryDocSnapshotStream.map((querysnapshot) => querysnapshot.docs);
    var eventsStream = docsStream.map((docs) => docs.map((doc) => doc.data()).toList());
    yield* eventsStream;
  }
  static Stream<List<EventModel>> listenEventsByCategory(String category)async*{
    var collection = getEventsCollection();
    var  queryDocSnapshotStream = collection.
    where('category',isEqualTo: category).snapshots();
    var docsStream = queryDocSnapshotStream.map((querysnapshot) => querysnapshot.docs);
    var eventsStream = docsStream.map((docs) => docs.map((doc) => doc.data()).toList());
    yield* eventsStream;
  }
  static CollectionReference<EventModel>getFavoritesCollection(){
    var userCollection = getUserCollection();
    var userDoc = userCollection.doc(auth.FirebaseAuth.instance.currentUser?.uid);
    var collection =userDoc.collection("Favorite").
    withConverter(
      fromFirestore: (snapshot, options) {
        var docSnapshot = snapshot.data();
        return EventModel.fromFireStore(docSnapshot);
      },
      toFirestore: (value, options) {
        return value.toFirStore();
      },
    );
    return collection;

  }
  static Future<void> addEventFavorite(EventModel event)async{
    var favoriteCollection = getFavoritesCollection();
    var doc = favoriteCollection.doc(event.id);
    return doc.set(event);
  }
  static Future<void> updateUser(List<String> favorites)async{
    var collection = getUserCollection();
    var doc = collection.doc(auth.FirebaseAuth.instance.currentUser?.uid);
    return doc.update({
      "favoriteList" : favorites
    });
  }
  static Future<void> deleteEventFavorite(EventModel event)async{
    var favoriteCollection = getFavoritesCollection();
    var doc = favoriteCollection.doc(event.id);
    return doc.delete();
  }
  static Stream<List<EventModel>> listenFavoriteEvents()async*{
    var collection = getFavoritesCollection();
    var  queryDocSnapshotStream = collection.snapshots();
    var docsStream = queryDocSnapshotStream.map((querysnapshot) => querysnapshot.docs);
    var eventsStream = docsStream.map((docs) => docs.map((doc) => doc.data()).toList());
    yield* eventsStream;
  }
}