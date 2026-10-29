import 'package:easy_localization/easy_localization.dart';
import 'package:evently/providers/themes_provider.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/ui/add_event/screen/add_event_screen.dart';
import 'package:evently/ui/details_event/screen/detials_event.dart';
import 'package:evently/ui/edit_event/screen/edit_event_screen.dart';
import 'package:evently/ui/forget_password/screen/forget_password_screen.dart';
import 'package:evently/ui/home/screen/home_screen.dart';
import 'package:evently/ui/onboarding/screen/onboarding_screen.dart';
import 'package:evently/ui/sign%20in/screen/signin_screen.dart';
import 'package:evently/ui/signup/screen/signup_screen.dart';
import 'package:evently/ui/start/screen/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/resources/app_theme.dart';
import 'core/resources/routes_manager.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('onboarding_seen') ?? false;


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ),
      ],
      child: EasyLocalization(
          supportedLocales: [
            Locale("en"),
            Locale("ar"),
          ],
          path: 'assets/translations',
          child: MyApp(seenOnboarding: seenOnboarding)
      ),
    ),
  );

}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});


  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme:AppTheme.lightTheme ,
      darkTheme: AppTheme.darkTheme,
      themeMode: provider.themeMode,
      routes: {
        RoutesManager.Start:(context)=>StartScreen(),
        RoutesManager.onboarding:(context)=>OnboardingScreen(),
        RoutesManager.signup:(context)=>SignupScreen(),
        RoutesManager.signin:(context)=>SignInScreen(),
        RoutesManager.forgetPass:(context)=> ForgetPasswordScreen(),
        RoutesManager.Home:(context)=>ChangeNotifierProvider(
          create: (context) => UserProvider() ..setUserValue(),
          child: HomeScreen()
        ),
        RoutesManager.addEvent:(context)=>AddEventScreen(),
        RoutesManager.DetailsEvent : (context) => DetialsEvent(),
        RoutesManager.editEvent : (context) => EditEventScreen(),


      },
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? RoutesManager.Home
          : seenOnboarding
            ? RoutesManager.signin
            : RoutesManager.Start,
    );
  }
}

