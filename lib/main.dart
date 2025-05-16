import 'package:finance_track/providers/bill_reminder_provider.dart';
import 'package:finance_track/providers/expense_statistics_provider.dart';
import 'package:finance_track/providers/home_provider.dart';
import 'package:finance_track/providers/login_provider.dart';
import 'package:finance_track/providers/login_session.dart';
import 'package:finance_track/providers/notification_provider.dart';
import 'package:finance_track/providers/profile_provider.dart';
import 'package:finance_track/providers/registerProvider.dart';
import 'package:finance_track/providers/theme_provider.dart';
import 'package:finance_track/providers/transaction_provider.dart';
import 'package:finance_track/screens/phone_screens/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/firebase_options.dart';
import 'package:is_wear/is_wear.dart';

final _isWearPlugin = IsWear();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isWears = await _isWearPlugin.check() ?? false;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812), // Base size (e.g. iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LoginProvider()),
              ChangeNotifierProvider(create: (_) => RegisterProvider()),
              ChangeNotifierProvider(create: (_) => HomeProvider()),
              ChangeNotifierProvider(create: (_) => ProfileProvider()),
              ChangeNotifierProvider(create: (_) => TransactionProvider()),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => TransactionProvider()),
              ChangeNotifierProvider(
                create: (_) => ExpenseStatisticsProvider(),
              ),
              ChangeNotifierProvider(create: (_) => BillReminderProvider()),
              ChangeNotifierProvider(create: (_) => LoginSession()),
              ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ],
            child: MyApp(isWear: isWears),
          ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isWear;
  const MyApp({super.key, required this.isWear});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      // home: widget.isWear ? WatchwearosHomescreen(): SplashScreen(),
      home: SplashScreen(isWear: widget.isWear),
    );
  }
}
