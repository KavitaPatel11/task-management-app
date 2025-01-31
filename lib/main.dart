import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:task_management_app/core/database/hive_service.dart';
import 'package:task_management_app/features/task/presentation/providers/user_preferences_provider.dart';
import 'package:task_management_app/features/task/presentation/views/task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().initHive();
  await HiveService().getUserPreferences();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isSplashScreenVisible = true;

  @override
  void initState() {
    super.initState();
    // Show splash screen for 2 seconds
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isSplashScreenVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPreferences = ref.watch(userPreferencesProvider);

    if (userPreferences == null) {
      ref.read(userPreferencesProvider.notifier).loadUserPreferences();
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Center(child: CircularProgressIndicator()), // Show loading spinner
      );
    }

    ThemeMode themeMode =
        userPreferences.theme == 'dark' ? ThemeMode.dark : ThemeMode.light;

    return MaterialApp(
  
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: _isSplashScreenVisible
          ? SplashScreen() // Show splash screen if true
          : TaskScreen(), // Show main screen when splash time is over
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // You can add a logo or animation here
      ),
    );
  }
}