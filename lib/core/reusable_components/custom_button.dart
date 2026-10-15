import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function() onClick;
  const CustomButton({super.key,required this.title,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
              )
          ),
          onPressed: onClick,
          child: Text(title,style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 20
          ),)),
    );
  }
}
