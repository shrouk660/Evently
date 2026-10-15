import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: .w500,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: icon,

          ),
        ],
      ),

    );
  }
}


