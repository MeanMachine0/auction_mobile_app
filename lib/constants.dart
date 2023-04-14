import 'package:flutter/material.dart';

class ApiConstants {}

class Colours {
  static const lightBlue = Color.fromARGB(255, 173, 216, 230);
  static const darkGray = Color.fromARGB(255, 84, 84, 84);
  static const deepGray = Color.fromARGB(255, 56, 56, 56);
  static const deepDarkGray = Color.fromARGB(255, 24, 24, 24);
  static const dimGray = Color.fromARGB(255, 112, 112, 112);
  static const lightGray = Color.fromARGB(255, 224, 224, 224);
  static const amber = Colors.amber;
  static const black = Colors.black;
  static const red = Color.fromARGB(255, 255, 0, 0);
  static const deepBlue = Color.fromARGB(255, 0, 0, 44);
}

class Regexes {
  static var money = RegExp(r'^\d{0,7}\.?\d{0,2}');
}

class Lists {
  static List<String> conditions = [
    'All',
    'New',
    'Excellent',
    'Good',
    'Used',
    'Refurbished',
    'Parts Only',
  ];

  static List<String> categories = [
    'All',
    'Business, Office & Industrial Supplies',
    'Health & Beauty',
    'Fashion',
    'Electronics',
    'Home Garden',
    'Sports, Hobbies & Leisure',
    'Motors',
    'Collectables & Art',
    'Media',
    'Others',
  ];

  static List<String> sorters = [
    'Price',
    'Name',
    'Time Remaining',
  ];
}

class Dicts {
  static Map<bool, String> toYesNo = {
    true: 'yes',
    false: 'no',
  };

  static Map<String, String> conditions = {
    'New': 'new',
    'Excellent': 'excellent',
    'Good': 'good',
    'Used': 'used',
    'Refurbished': 'refurbished',
    'Parts Only': 'partsOnly',
  };

  static Map<String, String> categories = {
    'Business, Office & Industrial Supplies': 'bOIS',
    'Health & Beauty': 'hB',
    'Fashion': 'f',
    'Electronics': 'e',
    'Home Garden': 'hG',
    'Sports, Hobbies & Leisure': 'sHL',
    'Motors': 'mt',
    'Collectables & Art': 'cA',
    'Media': 'mda',
    'Other': 'o',
  };

  static Map<String, String> sorters = {
    'Price': 'price',
    'Name': 'name',
    'Time Remaining': 'endDateTime',
  };
}

class Elements {
  static const cardHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colours.lightGray,
  );

  static const subHeader = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colours.lightGray,
  );

  static const cardText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colours.lightGray,
  );

  static const boldCardText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colours.lightGray,
  );
}
