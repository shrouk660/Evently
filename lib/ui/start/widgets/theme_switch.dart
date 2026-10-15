import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../providers/themes_provider.dart';

class ThemeSwitch extends StatelessWidget {
  final String iconPath;
  final ThemeMode mode;
  const ThemeSwitch({super.key,required this.iconPath,required this.mode});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: mode == themeProvider.themeMode
            ?Theme.of(context).colorScheme.primary
            :Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      onPressed: () {
        themeProvider.changeTheme(mode);
      },
      child: SvgPicture.asset(iconPath),
    );
  }
}
