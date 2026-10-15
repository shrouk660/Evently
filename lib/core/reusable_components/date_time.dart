
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:evently/core/resources/assets_manager.dart';

class EventDateTime extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  final VoidCallback onChooseDate;
  final VoidCallback onChooseTime;

  const EventDateTime({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onChooseDate,
    required this.onChooseTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AssetsManager.date,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Event Date',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onChooseDate,
              child: Text(
                selectedDate == null
                    ? 'Choose date'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Row(
          children: [
            SvgPicture.asset(
              AssetsManager.time,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Event Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onChooseTime,
              child: Text(
                selectedTime == null
                    ? 'Choose time'
                    : selectedTime!.format(context),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
