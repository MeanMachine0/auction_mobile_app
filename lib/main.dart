import 'dart:developer';
import 'dart:ui';

import 'package:auction_mobile_app/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:auction_mobile_app/pages/base.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    if (message.notification!.title == 'Outbidded!') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('notificationPage', int.parse(message.data['itemId']));
      await prefs.setBool('goToListing', true);
    }
  }
}

Future<void> main() async {
  Intl.defaultLocale = 'en-GB';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? fcmToken = await firebaseMessaging.getToken();
  if (fcmToken != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcmToken', fcmToken);
  }
  firebaseMessaging.onTokenRefresh.listen((fcmToken) {}).onError((err) {});
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (message.notification != null) {
      if (message.notification!.title == 'Outbidded!') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
            'notificationPage', int.parse(message.data['itemId']));
        await prefs.setBool('goToListing', true);
      }
    }
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auction App',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'GB'), Locale('en', 'US')],
      locale: const Locale('en', 'GB'),
      theme: ThemeData(
        colorSchemeSeed: Colours.deepDarkGray,
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: Colours.deepGray,
        navigationBarTheme:
            const NavigationBarThemeData(indicatorColor: Colors.transparent),
        cardTheme: const CardTheme(
          color: Colours.darkGray,
          elevation: 2,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colours.deepGray, toolbarHeight: 60),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colours.deepDarkGray),
        dataTableTheme: const DataTableThemeData(
          horizontalMargin: 15,
          headingTextStyle: TextStyle(fontSize: 16, color: Colours.lightGray),
          columnSpacing: 16,
          headingRowColor: MaterialStatePropertyAll(Colours.deepBlue),
          dataRowColor: MaterialStatePropertyAll(Colours.darkGray),
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colours.lightBlue),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          prefixIconColor: Colours.lightGray,
          suffixIconColor: Colours.lightGray,
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colours.red)),
          errorStyle: TextStyle(color: Colours.red),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.resolveWith<double?>((_) => 5),
            padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
                (_) =>
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => Colours.deepGray),
            textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                (states) => const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
          ),
        ),
      ),
      home: const Base(),
    );
  }
}
