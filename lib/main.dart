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
        scaffoldBackgroundColor: Colours.dimGray,
        cardTheme: const CardTheme(
          color: Colours.lightGray,
          elevation: 5,
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.black, fontSize: 12),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
          bodyLarge: TextStyle(color: Colors.black, fontSize: 20),
          labelSmall: TextStyle(color: Colors.black, fontSize: 12),
          labelMedium: TextStyle(color: Colors.black, fontSize: 16),
          labelLarge: TextStyle(color: Colors.black, fontSize: 20),
          displaySmall: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displayLarge: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
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
      ),
      home: const Base(),
    );
  }
}
