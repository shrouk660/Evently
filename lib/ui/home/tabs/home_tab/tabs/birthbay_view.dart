import 'package:evently/core/resources/string_manager.dart';
import 'package:evently/ui/home/widget/event_card.dart';
import 'package:flutter/material.dart';
import '../../../../../core/remote/network/firestore_manager.dart';
import '../../../../../model/event_model.dart';

class BirthdayView extends StatelessWidget {
  const BirthdayView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreManager.listenEventsByCategory("Birthday"),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasError){
          return Column(
            children: [
              Text(snapshot.error.toString()),
              ElevatedButton(
                onPressed: (){

                },
                child:Text("Try Again"),
              )
            ],
          );
        }
        List<EventModel> events = snapshot.data??[];
        if(events.isEmpty){
          return Center(child: Text(StringsManager.noEventsFound,style: Theme.of(context).textTheme.bodyMedium,),);
        }
        return ListView.separated(
          itemBuilder:(context, index) => EventCard(event: events[index]) ,
          separatorBuilder: (context,index) => SizedBox(height: 16,),
          itemCount: events.length,
        );
      },
    );
  }
}