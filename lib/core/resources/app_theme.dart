import 'package:flutter/material.dart';

import 'colors_manager.dart';

class AppTheme {
  static ThemeMode themeMode = ThemeMode.light;
  static ThemeData lightTheme = ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(
          fontWeight: .w400,
          fontSize: 12,
          color: ColorsManager.lightPrimary
        ),
        unselectedLabelStyle:TextStyle(
            fontWeight: .w400,
            fontSize: 12,
            color: ColorsManager.unselectedTabColor
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        trackOutlineWidth: WidgetStateProperty.all(0),
        thumbColor: WidgetStateProperty.all(Colors.white),
        thumbIcon: WidgetStateProperty.all(
          const Icon(Icons.circle, color: Colors.transparent),
        ),
        trackColor: WidgetStateProperty.all(ColorsManager.lightswitch),
      ),
      colorScheme: ColorScheme.light(
          primary: ColorsManager.lightPrimary,
          onPrimary:ColorsManager.lightPrimary,
          onPrimaryContainer: ColorsManager.whiteColor,
          secondary: ColorsManager.lightFieldBorderColor,
          onSurface: ColorsManager.blackColor,
          outline: ColorsManager.whiteColor,


      ),
      scaffoldBackgroundColor: ColorsManager.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      textTheme: TextTheme(
          titleMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ColorsManager.blackColor
          ),
          bodySmall:TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorsManager.lightSecondaryColor
          ),
          labelMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorsManager.whiteColor
          ),
          labelSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorsManager.lightPrimary
          ),
          titleSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorsManager.lightPrimary,
              decoration: TextDecoration.underline,
              decorationColor: ColorsManager.lightPrimary
          )
      )
  );
  static ThemeData darkTheme = ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorsManager.darkBackground,
        selectedLabelStyle: TextStyle(
            fontWeight: .w400,
            fontSize: 12,
            color: ColorsManager.darkPrimary
        ),
        unselectedLabelStyle:TextStyle(
            fontWeight: .w400,
            fontSize: 12,
            color: ColorsManager.unselectedTabColor
        ),
      ),
      colorScheme: ColorScheme.dark(
          primary: ColorsManager.darkPrimary,
          onPrimary:ColorsManager.whiteColor,
          onPrimaryContainer: ColorsManager.darkUnselectedSettings,
          secondary: ColorsManager.darkFieldBorderColor,
          onSurface: ColorsManager.whiteColor,
          outline: ColorsManager.darkFieldBorderColor,
      ),
      scaffoldBackgroundColor: ColorsManager.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      textTheme: TextTheme(
          titleMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ColorsManager.whiteColor
          ),
          bodySmall:TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorsManager.darkSecondaryColor
          ),
          labelMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorsManager.whiteColor
          ),
          labelSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorsManager.whiteColor
          ),
          titleSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorsManager.darkPrimary,
              decoration: TextDecoration.underline,
              decorationColor: ColorsManager.darkPrimary
          )
      )

  );
}