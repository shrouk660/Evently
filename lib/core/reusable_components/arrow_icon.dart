import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class ArrowIcon extends StatelessWidget {
  final VoidCallback? onClick;
  final String icon;
  final Color? iconColor;

  const ArrowIcon({
    required this.onClick,
    required this.icon,
    this.iconColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClick,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: SvgPicture.asset(
        icon,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          iconColor ?? Theme.of(context).colorScheme.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
