import 'package:flutter/material.dart';

class Ordivider extends StatelessWidget {
  const Ordivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Theme.of(context).colorScheme.secondary,)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Or", style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: .w600
          )

          )
        ),
        Expanded(child: Divider(color: Theme.of(context).colorScheme.secondary,)),
      ],
    );
  }
}
