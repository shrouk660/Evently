import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/remote/network/firestore_manager.dart';
import 'package:evently/core/resources/dialod_utils.dart';
import 'package:evently/core/resources/string_manager.dart';
import 'package:evently/core/reusable_components/arrow_icon.dart';
import 'package:evently/core/reusable_components/time.dart';
import 'package:evently/model/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../../core/resources/assets_manager.dart';
import '../../../core/reusable_components/category_chip.dart';
import '../../../core/reusable_components/custom_button.dart';
import '../../../core/reusable_components/custom_field.dart';
import '../../../core/reusable_components/date.dart';
import '../../../model/event_categories.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static  List<EventCategory> get  categories => EventCategories.all;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  int selectedTap = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  Future<void>addEvent()async{
    if(formKey.currentState!.validate()) {
      if(selectedTime!= null && selectedDate!= null) {
        DialodUtils.showLoadingDialog(context);
        await FirestoreManager.saveEvent(EventModel(
          userId: FirebaseAuth.instance.currentUser?.uid,
          title: titleController.text,
          description: descriptionController.text,
          dateAndTime: Timestamp.fromDate(DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
            selectedTime!.hour,
            selectedTime!.minute,
          )),
          category: categories[selectedTap].title,

        ));
        Navigator.of(context).pop();
        SnackBar snackBar = SnackBar(content: Text("Event Created successfully"),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        SnackBar snackBar = SnackBar(content: Text("Date and time are required"),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: ArrowIcon(
              onClick: (){
                Navigator.of(context).pop();
              },
              icon:  AssetsManager.arrowLeft,
          ),
        ),
        title: Text(StringsManager.addEvent,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
      ),
      body: DefaultTabController(
        length: categories.length,
        child: SafeArea(
           child: SingleChildScrollView(
             child: Padding(
               padding: EdgeInsets.all(16),
               child: Form(
                 key: formKey,
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
                           child: TabBarView(
                               physics: const NeverScrollableScrollPhysics(),
                               children: categories .map((c)=>Image.asset(
                                 Theme.of(context).brightness == Brightness.dark
                                     ? c.bannerDark
                                     : c.bannerLight,
                                 height: 180,
                                 width: double.infinity,
                                 fit: BoxFit.cover,
                               ),).toList()
                           ),
                         )
                       ),
                       const SizedBox(height: 16),
                       Builder(
                         builder: (context){
                           final controller = DefaultTabController.of(context);
                           return AnimatedBuilder(
                             animation: controller,
                             builder: (context, _) => TabBar(
                               physics: NeverScrollableScrollPhysics(),
                               isScrollable: true,
                               tabAlignment: TabAlignment.start,
                               padding: EdgeInsets.zero,
                               dividerColor: Colors.transparent,
                               indicator: const BoxDecoration(),
                               splashFactory: NoSplash.splashFactory,
                               overlayColor:
                               WidgetStateProperty.all(Colors.transparent),
                               labelPadding: const EdgeInsets.only(right: 8),
                               tabs: List.generate(
                                 categories.length,
                                     (i) => Tab(
                                   height: 40,
                                   child: CategoryChip(
                                     title: categories[i].title,
                                     image: categories[i].icon,
                                     isSelected: controller.index == i,
                                     onTap: () {
                                       selectedTap = i;
                                       controller.animateTo(i);
                                     },
                                   ),
                                 ),
                               ),
                             ),
                           );
                         },
                       ),
                       const SizedBox(height: 16),
                       Text(StringsManager.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                           fontWeight: .w500,
                           fontSize: 16
                       )),
                       const SizedBox(height: 8),
                       CustomField(
                         controller: titleController,
                         validation: (value) {
                           if (value == null || value.trim().isEmpty) {
                             return StringsManager.titleCantBeEmpty;
                           }
                           return null;
                         },
                         hint: StringsManager.eventTitle,
                         keyboard: TextInputType.text,
                       ),
                       const SizedBox(height: 16),
                       Text(StringsManager.description, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                           fontWeight: .w500,
                           fontSize: 16
                       )),
                       const SizedBox(height: 8),
                       CustomField(
                         controller: descriptionController,
                         validation: (value) {
                           if (value == null || value.trim().isEmpty) {
                             return StringsManager.descriptionCantBeEmpty;
                           }
                           return null;
                         },
                         hint: StringsManager.eventDescription,
                         keyboard: TextInputType.multiline,
                         maxLines: 5,
                       ),
                       const SizedBox(height: 16),
                       Date(onDateSelected: (d) => selectedDate = d),
                       const SizedBox(height: 12),
                       Time(onTimeSelected: (t) => selectedTime = t),
                       const SizedBox(height: 24),
                       CustomButton(
                         title: StringsManager.addEvent,
                         onClick: (){
                           addEvent();
                         } ,
                       ),

                     ],
                   )
               ),
             ),
           )
        ),
      ),
    );
  }
}
