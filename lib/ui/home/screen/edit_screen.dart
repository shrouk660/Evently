import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/resources/assets_manager.dart';
import '../../../core/reusable_components/category_chip.dart';
import '../../../core/reusable_components/custom_button.dart';
import '../../../core/reusable_components/custom_field.dart';
import '../../../core/reusable_components/date_time.dart';
import '../../../model/event_categories.dart';
import '../../../model/event_model.dart';
import '../../../providers/events_provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  static const categories = EventCategories.all;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  late EventModel event;
  late int selectedIndex;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    event = ModalRoute.of(context)!.settings.arguments as EventModel;

    titleController.text = event.title;
    descriptionController.text = event.description;
    selectedDate = event.date;
    selectedTime = TimeOfDay(hour: event.hour, minute: event.minute);

    final index = categories.indexWhere((c) => c.title == event.category);
    selectedIndex = index == -1 ? 0 : index;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate.isBefore(now) ? selectedDate : now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) setState(() => selectedTime = time);
  }

  void updateEvent() {
    if (!formKey.currentState!.validate()) return;

    final category = categories[selectedIndex];

    final updated = event.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: category.title,
      date: selectedDate,
      hour: selectedTime.hour,
      minute: selectedTime.minute,
      bannerLight: category.bannerLight,
      bannerDark: category.bannerDark,
    );

    context.read<EventsProvider>().updateEvent(event, updated);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          style: IconButton.styleFrom(
            backgroundColor: colors.onPrimaryContainer,
            side: BorderSide(color: colors.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: SvgPicture.asset(
            AssetsManager.arrowLeft,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(colors.onPrimary, BlendMode.srcIn),
          ),
        ),
        title: Text(
          "Edit event",
          style: texts.titleMedium?.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
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
                    border: Border.all(color: colors.secondary),
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
                Text(
                  "Title",
                  style: texts.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
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
                Text(
                  "Description",
                  style: texts.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
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
                  title: "Update event",
                  onClick: updateEvent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}