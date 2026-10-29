import 'package:flutter/material.dart';

class LanguageSwitch extends StatelessWidget {
  final String title;
  final String languageCode;
  final String selectedLanguage;
  final double? height;
  final double? widgh;
  final void Function() onClicked;
  const LanguageSwitch({
    super.key,
    this.height,
    this.widgh,
    required this.onClicked,
    required this.title,
    required this.languageCode,
    required this.selectedLanguage
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widgh,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: languageCode == selectedLanguage
              ?Theme.of(context).colorScheme.primary
              :Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        onPressed: onClicked,
        child: Text(title, style: languageCode == selectedLanguage
            ?Theme.of(context).textTheme.labelMedium
            :Theme.of(context).textTheme.labelSmall),
      ),
    );
  }
}
