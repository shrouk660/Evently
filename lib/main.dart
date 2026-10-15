import 'package:evently/providers/events_provider.dart';
import 'package:evently/providers/themes_provider.dart';
import 'package:evently/ui/add_event/screen/add_event_screen.dart';
import 'package:evently/ui/home/screen/edit_screen.dart';
import 'package:evently/ui/home/screen/event_details_screen.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('onboarding_seen') ?? false;


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventsProvider(),
        ),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );

}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:AppTheme.lightTheme ,
      darkTheme: AppTheme.darkTheme,
      themeMode: provider.themeMode,
      routes: {
        RoutesManager.Start:(context)=>StartScreen(),
        RoutesManager.signup:(context)=>SignupScreen(),
        RoutesManager.signin:(context)=>SignInScreen(),
        RoutesManager.Home:(context)=>HomeScreen(),
        RoutesManager.onboarding:(context)=>OnboardingScreen(),
        RoutesManager.addEvent:(context)=>AddEventScreen(),
        RoutesManager.eventDetails: (_) => EventDetailsScreen(),
        RoutesManager.editEvent: (_) => EditScreen(),
      },
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? RoutesManager.Home
          : seenOnboarding
            ? RoutesManager.signin
            : RoutesManager.Start,
    );
  }
}

