import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/remote/network/firestore_manager.dart';
import 'package:flutter/material.dart';

import '../../../core/resources/assets_manager.dart';
import '../../../core/reusable_components/arrow_icon.dart';
import '../../../core/reusable_components/category_chip.dart';
import '../../../core/reusable_components/custom_button.dart';
import '../../../core/reusable_components/custom_field.dart';
import '../../../core/reusable_components/date.dart';
import '../../../core/reusable_components/time.dart';
import '../../../model/event_categories.dart';
import '../../../model/event_model.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static const categories = EventCategories.all;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  int selectedTap = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isInit = false;
  late EventModel event;

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
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(isInit)return;
    isInit = true;
    event = ModalRoute.of(context)!.settings.arguments as EventModel;
    titleController.text = event.title?? "";
    descriptionController.text = event.description??"";
    final index = categories.indexWhere((c) => c.title == event.category);
    selectedTap = index == -1 ? 0 : index;
    final dateAndTime= event.dateAndTime?.toDate();
    selectedDate = dateAndTime;
    selectedTime = dateAndTime == null
        ? null
        :TimeOfDay.fromDateTime(dateAndTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: ArrowIcon(
            onClick: (){
              Navigator.of(context).pop();
            },
            icon:  AssetsManager.arrowLeft,
          ),
        ),
        title: Text("Edit event",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
      ),
      body: DefaultTabController(
        length: categories.length,
        initialIndex: selectedTap,
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
                        Text("Title",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: .w500,
                            fontSize: 16
                        )),
                        const SizedBox(height: 8),
                        CustomField(
                          controller: titleController,
                          validation: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Title can't be empty";
                            }
                            return null;
                          },
                          hint: "Event Title",
                          keyboard: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        Text("Description", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: .w500,
                            fontSize: 16
                        )),
                        const SizedBox(height: 8),
                        CustomField(
                          controller: descriptionController,
                          validation: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Description can't be empty";
                            }
                            return null;
                          },
                          hint: "Event Description...",
                          keyboard: TextInputType.multiline,
                          maxLines: 5,
                        ),
                        const SizedBox(height: 16),
                        Date(
                          selectedDate: selectedDate,
                          onDateSelected: (d) => selectedDate = d,
                        ),
                        const SizedBox(height: 12),
                        Time(
                          selectedTime: selectedTime,
                          onTimeSelected: (t) => selectedTime = t,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          title: "Update event",
                          onClick: updateEvent,
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
  Future<void>updateEvent()async{
    if(!formKey.currentState!.validate())return;
    if(selectedDate == null || selectedTime == null){
      SnackBar snackBar = SnackBar(content: Text("Date and time are required"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    event.title = titleController.text.trim();
    event.description = descriptionController.text.trim();
    event.category = categories[selectedTap].title;
    event.dateAndTime = Timestamp.fromDate(DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
    ));
    try{
      await FirestoreManager.updateEvent(event);
      if(!mounted)return;
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      SnackBar snackBar = SnackBar(content: Text("Event Updated successfully"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }catch(e){
      if(!mounted)return;
      SnackBar snackBar = SnackBar(content: Text("Failed to update : $e"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }


}
