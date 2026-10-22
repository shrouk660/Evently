
import 'package:evently/core/remote/network/firestore_manager.dart';
import 'package:evently/core/resources/dialod_utils.dart';
import 'package:evently/core/resources/routes_manager.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../model/event_categories.dart';
import '../../../model/event_model.dart';

class EventCard extends StatefulWidget {
  final EventModel event;

  const EventCard({
    super.key,
    required this.event,

  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = EventCategories.byTitle(widget.event.category);
    final date = widget.event.dateAndTime?.toDate() ?? DateTime.now();
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 220,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark
              ?Theme.of(context).colorScheme.primary
              :Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            RoutesManager.DetailsEvent,
            arguments: widget.event,
          );
        },
        borderRadius: BorderRadius.circular(22),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                isDark ? category.bannerDark : category.bannerLight,
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(
                      color: isDark
                          ?Theme.of(context).colorScheme.primary
                          :Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                      '${date.day} ${_monthName(date.month)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(
                      color: isDark
                          ?Theme.of(context).colorScheme.primary
                          :Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.event.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                       IconButton(
                         onPressed: (){
                           heartCliced(userProvider);
                         },
                         icon:  SvgPicture.asset(
                           userProvider.user?.favorites?.contains(widget.event.id!)?? false
                               ?AssetsManager.heart_selected
                               :AssetsManager.heart,
                          width: 26,
                          height: 26,
                         ),
                       ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return months[month - 1];
  }

  heartCliced(UserProvider userProvider )async{
    if(userProvider.user?.favorites?.contains(widget.event.id!)??false){
      DialodUtils.showLoadingDialog(context);
      await FirestoreManager.deleteEventFavorite(widget.event);
      userProvider.user?.favorites?.remove(widget.event.id!);
      await FirestoreManager.updateUser(userProvider.user?.favorites??[]);
      Navigator.of(context).pop();
      SnackBar snackBar = SnackBar(content: Text("Event removed from your favorite"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }else{
      DialodUtils.showLoadingDialog(context);
      await FirestoreManager.addEventFavorite(widget.event);
      userProvider.user?.favorites?.add(widget.event.id!);
      await FirestoreManager.updateUser(userProvider.user?.favorites??[]);
      Navigator.of(context).pop();
      SnackBar snackBar = SnackBar(content: Text("Event added to your favorite"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {

    });

  }
}
