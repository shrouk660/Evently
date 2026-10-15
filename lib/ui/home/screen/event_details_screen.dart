import 'package:evently/core/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/routes_manager.dart';
import '../../../model/event_model.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  Widget _appBarButton(
      BuildContext context, {
        required String icon,
        required VoidCallback onPressed,
        required Color iconColor,
        Color? borderColor,
      }) {
    final colors = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: colors.onPrimaryContainer,
        side: BorderSide(color: borderColor ?? colors.secondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: SvgPicture.asset(
        icon,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as EventModel;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final texts = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final eventTime = TimeOfDay(
      hour: event.hour,
      minute: event.minute,
    ).format(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: _appBarButton(
          context,
          icon: AssetsManager.arrowLeft,
          iconColor: colors.primary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Event details',
          style: texts.titleMedium?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          _appBarButton(
            context,
            icon: AssetsManager.edit,
            iconColor: colors.primary,
            onPressed: () {
              Navigator.of(context).pushNamed(
                RoutesManager.editEvent,
                arguments: event,
              );
            },
          ),
          _appBarButton(
            context,
            icon: AssetsManager.trash,
            iconColor: ColorsManager.deleteColor,
            borderColor: Theme.of(context).colorScheme.outline,
            onPressed: () {

            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.onPrimaryContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.secondary),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? event.bannerDark
                      : event.bannerLight,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              event.title,
              style: texts.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.onPrimaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.secondary),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: isDark
                          ? Border.all(
                        color: colors.primary.withValues(alpha: 0.5),
                      )
                          : null,
                    ),
                    child: SvgPicture.asset(
                      AssetsManager.date,
                      colorFilter: ColorFilter.mode(
                        colors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${event.date.day} ${_monthName(event.date.month)}',
                          style: texts.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? colors.primary : colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          eventTime,
                          style: texts.bodySmall?.copyWith(
                            fontSize: 14,
                            color: isDark ? colors.onSurface : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Description',
              style: texts.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.onPrimaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.secondary),
              ),
              child: Text(
                event.description,
                style: texts.bodySmall?.copyWith(
                  fontSize: 14,
                  height: 1.6,
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}