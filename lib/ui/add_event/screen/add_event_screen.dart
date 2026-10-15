import 'package:evently/core/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/reusable_components/category_chip.dart';
import '../../../core/reusable_components/custom_button.dart';
import '../../../core/reusable_components/custom_field.dart';
import '../../../core/reusable_components/date_time.dart';
import '../../../model/event_categories.dart';
import '../../../model/event_model.dart';
import '../../../providers/events_provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  static const categories = EventCategories.all;

  int selectedIndex = 0;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  void addEvent() {
    if (!formKey.currentState!.validate()) return;

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose date and time'),
        ),
      );
      return;
    }

    final selectedCategory = categories[selectedIndex];

    final event = EventModel(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory.title,
      date: selectedDate!,
      hour: selectedTime!.hour,
      minute: selectedTime!.minute,
      bannerLight: selectedCategory.bannerLight,
      bannerDark: selectedCategory.bannerDark,
    );

    context.read<EventsProvider>().addEvent(event);

    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              side: BorderSide(color: Theme.of(context).colorScheme.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),

              ),
            ),
            icon: SvgPicture.asset(
              AssetsManager.arrowLeft,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
            )
        ),
        title: Text("Add event",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),

      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Image.asset(
                                  Theme.of(context).brightness == Brightness.dark
                                      ? categories[selectedIndex].bannerDark
                                      : categories[selectedIndex].bannerLight,
                                  key: ValueKey(selectedIndex),
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, i) => CategoryChip(
                                title: categories[i].title,
                                image: categories[i].icon,
                                isSelected: selectedIndex == i,
                                onTap: () => setState(() => selectedIndex = i),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text("Title", style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                          EventDateTime(
                            selectedDate: selectedDate,
                            selectedTime: selectedTime,
                            onChooseDate: pickDate,
                            onChooseTime: pickTime,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            title: "Add event",
                            onClick: addEvent ,
                          ),

                        ],
                    )
                  ),
                )
            )

          ],
        ),
      ),
    );
  }
}
