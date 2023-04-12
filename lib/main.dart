import 'package:flutter/material.dart';
import 'package:auction_mobile_app/pages/base.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Intl.defaultLocale = 'en-GB';
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
