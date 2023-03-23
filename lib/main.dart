import 'package:flutter/material.dart';
import 'package:my_rest_api/pages/base.dart';
import 'package:my_rest_api/colours.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auction App',
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colours.deepGray,
        cardTheme: const CardTheme(
          color: Colours.darkGray,
          elevation: 2,
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colours.lightGray, fontSize: 12),
          bodyMedium: TextStyle(color: Colours.lightGray, fontSize: 16),
          bodyLarge: TextStyle(color: Colours.lightGray, fontSize: 20),
          labelSmall: TextStyle(color: Colours.lightGray, fontSize: 12),
          labelMedium: TextStyle(color: Colours.lightGray, fontSize: 16),
          labelLarge: TextStyle(color: Colours.lightGray, fontSize: 20),
          displaySmall: TextStyle(color: Colours.lightGray),
          displayMedium: TextStyle(color: Colours.lightGray),
          displayLarge: TextStyle(color: Colours.lightGray),
          titleSmall: TextStyle(color: Colours.lightGray),
          titleMedium: TextStyle(color: Colours.lightGray),
          titleLarge: TextStyle(color: Colours.lightGray),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colours.lightGray, fontSize: 24),
          color: Colours.deepGray,
        ),
        dataTableTheme: const DataTableThemeData(
          horizontalMargin: 10,
          headingTextStyle: TextStyle(fontSize: 16),
          columnSpacing: 16,
          headingRowColor: MaterialStatePropertyAll(Colours.darkGray),
          dataRowColor: MaterialStatePropertyAll(Colours.lightGray),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: Colours.lightGray,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colours.darkGray,
          prefixIconColor: Colours.lightGray,
        ),
      ),
      home: const Base(),
    );
  }
}
