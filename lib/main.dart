import 'package:finance_track/providers/MessageProvider.dart';
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
import 'package:is_wear/is_wear.dart';

<<<<<<< HEAD
import 'package:permission_handler/permission_handler.dart';  // <-- Added
import 'utils/firebase_options.dart';

=======
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
final _isWearPlugin = IsWear();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD


  await _requestNotificationPermission();

=======
  bool isWears = await _isWearPlugin.check() ?? false;
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  bool isWear = await _isWearPlugin.check() ?? false;

  runApp(
<<<<<<< HEAD
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseStatisticsProvider()),
        ChangeNotifierProvider(create: (_) => BillReminderProvider()),
        ChangeNotifierProvider(create: (_) => LoginSession()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MyApp(isWear: isWear),
=======
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
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
    ),
  );
}

Future<void> _requestNotificationPermission() async {
  // Request permission using permission_handler package
  if (await Permission.notification.isDenied) {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
    }
  }
}

class MyApp extends StatefulWidget {
  final bool isWear;
  const MyApp({super.key, required this.isWear});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = true; // Firebase already initialized before runApp

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
<<<<<<< HEAD
=======
      // home: widget.isWear ? WatchwearosHomescreen(): SplashScreen(),
>>>>>>> 65d963a0c7547f9cf5d19cabe558af55a22f0ac1
      home: SplashScreen(isWear: widget.isWear),
    );
  }
}
