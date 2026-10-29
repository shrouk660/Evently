import 'package:flutter/material.dart';
import '../resources/assets_manager.dart';

class GoogleButton extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;

  const GoogleButton({super.key, required this.title, this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.transparent
              : Theme.of(context).colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color:Theme.of(context).colorScheme.secondary),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsManager.google),
            const SizedBox(width: 12),
            Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: .w600
            )),
          ],
        ),
      ),
    );
  }
}
