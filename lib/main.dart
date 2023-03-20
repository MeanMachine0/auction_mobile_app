import 'package:flutter/material.dart';
import 'package:my_rest_api/pages/home.dart';

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
        primaryColor: Colors.black,
      ),
      home: const Home(),
    );
  }
}
