import 'package:evently/core/resources/routes_manager.dart';
import 'package:evently/core/resources/string_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/remote/network/firestore_manager.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/colors_manager.dart';
import '../../../core/reusable_components/arrow_icon.dart';
import '../../../model/event_categories.dart';
import '../../../model/event_model.dart';

class DetialsEvent extends StatefulWidget {
  const DetialsEvent({super.key});

  @override
  State<DetialsEvent> createState() => _DetialsEventState();
}
class _DetialsEventState extends State<DetialsEvent> {
  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as EventModel;
    final isOwner = event.userId == FirebaseAuth.instance.currentUser?.uid;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = EventCategories.byId(event.category);
    final date = event.dateAndTime?.toDate();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: ArrowIcon(
            onClick: (){
              Navigator.of(context).pop();
            },
            icon:  AssetsManager.arrowLeft,
          ),
        ),
        title: Text(StringsManager.eventDetails,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
        actions:isOwner
        ? [
          ArrowIcon(
            onClick: (){
              Navigator.of(context).pushNamed(
                RoutesManager.editEvent,
                arguments: event,
              );
            },
            icon: AssetsManager.edit
          ),
          SizedBox(width:8 ,),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: ArrowIcon(
                onClick: (){
                  deleteEvent(event);
                },
                icon: AssetsManager.trash,
               iconColor: ColorsManager.deleteColor,
            ),
          ),
        ]
        :null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ?category.bannerDark : category.bannerLight,
                      fit: BoxFit.cover,

                  )
                )
              ),
              const SizedBox(height: 16),
              Text(
                event.title ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: isDark
                              ?Theme.of(context).colorScheme.primary
                              :Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SvgPicture.asset(
                        AssetsManager.date,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date == null ? "" : "${date.day} ${_monthName(date.month)} ${date.year}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date == null ? "" : TimeOfDay.fromDateTime(date).format(context),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(StringsManager.description, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: .w500,
                  fontSize: 16
              )),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Text(
                  event.description ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      )

    );
  }
  Future<void> deleteEvent(EventModel event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text(StringsManager.deleteEvent),
        content: Text(StringsManager.areYouSureYouWantToDeleteThisEvent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(StringsManager.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              StringsManager.delete,
              style: TextStyle(color: ColorsManager.deleteColor),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    try {
      await FirestoreManager.deletEvent(event);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(StringsManager.eventDeletedSuccessfully)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${StringsManager.failedToDelete} $e")),
      );
    }
  }
  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }
}
