import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).brightness == Brightness.dark
                ? Colors.transparent
                : Theme.of(context).colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(46),
          border: Border.all(color: Theme.of(context).colorScheme.secondary),

        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              image,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}