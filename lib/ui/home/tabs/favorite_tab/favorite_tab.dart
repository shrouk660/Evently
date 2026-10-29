import 'package:evently/core/resources/assets_manager.dart';
import 'package:evently/core/resources/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/remote/network/firestore_manager.dart';

import '../../widget/event_card.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  final searchController =  TextEditingController();
  String query ="";
  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) => setState(() => query = value.trim()),
              decoration: InputDecoration(
                hintText: StringsManager.searchForEvent,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    AssetsManager.search,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16,),
            Expanded(
              child: StreamBuilder(
                stream: FirestoreManager.listenFavoriteEvents(),
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
                          child:Text(StringsManager.tryAgain),
                        )
                      ],
                    );
                  }
                  final all = snapshot.data ?? [];
                  final events = query.isEmpty
                      ? all
                      : all
                      .where((e) => (e.title ?? "")
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                      .toList();
                  if(events.isEmpty){
                    return Center(child: Text(StringsManager.noEventsFound,style: Theme.of(context).textTheme.bodyMedium,),);
                  }
                  return ListView.separated(
                    itemBuilder:(context, index) => EventCard(event: events[index]) ,
                    separatorBuilder: (context,index) => SizedBox(height: 16,),
                    itemCount: events.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
