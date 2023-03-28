import 'package:flutter/material.dart';

import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ListAnItem extends StatefulWidget {
  const ListAnItem({Key? key}) : super(key: key);

  @override
  _ListAnItemState createState() => _ListAnItemState();
}

class RegexInputFormatter extends TextInputFormatter {
  final List<RegExp> patterns;

  RegexInputFormatter(this.patterns);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    for (int i = 0; i < newValue.text.length; i++) {
      if (i < patterns.length && !patterns[i].hasMatch(newValue.text[i])) {
        return oldValue;
      }
    }
    return newValue;
  }
}

class _ListAnItemState extends State<ListAnItem> {
  final listFormKey = GlobalKey<FormState>();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController startingPriceController = TextEditingController();
  TextEditingController postageCostController = TextEditingController();
  TextEditingController bidIncrementController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  String conditionOption = '';
  List<String> conditionOptions = [
    'New',
    'Excellent',
    'Good',
    'Used',
    'Refurbished',
    'Parts Only'
  ];
  bool acceptReturns = false;
  DateTime endDate = DateTime(0);
  late int? accountId = 0;
  late String? token = '';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountId = prefs.getInt('userId');
    token = prefs.getString('token');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your New Listing'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(13),
          child: Form(
            key: listFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                TextFormField(
                    controller: itemNameController,
                    maxLength: 50,
                    validator: (name) {
                      if (name! == '') {
                        return 'Please enter an item name.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colours.red)),
                      errorStyle: TextStyle(color: Colours.red),
                      label: Text('Item name'),
                    )),
                const SizedBox(height: 13),
                TextFormField(
                    controller: startingPriceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(Regexes.money)
                    ],
                    validator: (price) {
                      if (price! == '') {
                        return 'Please enter a starting price.';
                      } else if (double.tryParse(price)! < 0.01) {
                        return 'Starting price must be > £0!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colours.red)),
                      errorStyle: TextStyle(color: Colours.red),
                      label: Text('Starting Price (£)'),
                    )),
                const SizedBox(height: 13),
                TextFormField(
                    controller: postageCostController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(Regexes.money)
                    ],
                    validator: (postageCost) {
                      if (postageCost! == '') {
                        return 'Please enter a P&P value.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colours.red)),
                      errorStyle: TextStyle(color: Colours.red),
                      label: Text('P&P (£)'),
                    )),
                const SizedBox(height: 13),
                TextFormField(
                    controller: bidIncrementController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(Regexes.money)
                    ],
                    validator: (price) {
                      if (price! == '') {
                        return 'Please enter a bid increment.';
                      } else if (double.tryParse(price)! < 0.01) {
                        return 'Bid increment must be > £0!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colours.red)),
                      errorStyle: TextStyle(color: Colours.red),
                      label: Text('Bid Increment (£)'),
                    )),
                const SizedBox(height: 13),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colours.red)),
                    errorStyle: TextStyle(color: Colours.red),
                    label: Text('Condition'),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      conditionOption = newValue!;
                    });
                  },
                  validator: (condition) {
                    if (!conditionOptions.contains(condition)) {
                      return 'Please select a condition';
                    }
                    return null;
                  },
                  items: conditionOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 13),
                InputDatePickerFormField(
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  fieldLabelText: 'End Date',
                  fieldHintText: 'dd/MM/yyyy',
                  errorInvalidText: 'Must be within 30 days from now.',
                  onDateSubmitted: (date) {
                    print(date);
                    setState(() {
                      endDate = date;
                    });
                  },
                  onDateSaved: (date) {
                    print(date);
                    setState(() {
                      endDate = date;
                    });
                  },
                ),
                const SizedBox(height: 13),
                TextFormField(
                    controller: endTimeController,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      RegexInputFormatter([
                        Regexes.number,
                        Regexes.number,
                        Regexes.colon,
                        Regexes.number,
                        Regexes.number
                      ]),
                    ],
                    maxLength: 5,
                    validator: (time) {
                      if (time! == '') {
                        return 'Please enter a time.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colours.red)),
                      errorStyle: TextStyle(color: Colours.red),
                      label: Text('End Time (HH:mm)'),
                    )),
                const SizedBox(height: 13),
                CheckboxListTile(
                  activeColor: Colours.deepGray,
                  checkColor: Colours.lightGray,
                  selectedTileColor: Colors.transparent,
                  tileColor: Colours.darkGray,
                  title: const Text('Accept Returns?'),
                  value: acceptReturns,
                  onChanged: (value) {
                    setState(() {
                      acceptReturns = value!;
                    });
                  },
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 7,
                  maxLength: 1000,
                  validator: (desc) {
                    if (desc!.trim() == '') {
                      return 'Please enter a description.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colours.red)),
                    errorStyle: TextStyle(color: Colours.red),
                    label: Text('Description'),
                  ),
                ),
                const SizedBox(height: 13),
                ElevatedButton(
                    onPressed: () {
                      listFormKey.currentState!.save();
                      if (conditionOption == 'Parts Only') {
                        conditionOption = 'partsOnly';
                      } else {
                        conditionOption = conditionOption.toLowerCase();
                      }
                      ApiService apiService = ApiService();
                      var hoursMinutes = endTimeController.text.split(':');
                      // ignore: no_leading_underscores_for_local_identifiers
                      int _hours = int.parse(hoursMinutes[0]);
                      // ignore: no_leading_underscores_for_local_identifiers
                      int _minutes = int.parse(hoursMinutes[1]);
                      DateTime endDateTime = endDate
                          .add(Duration(hours: _hours, minutes: _minutes));
                      if (listFormKey.currentState!.validate()) {
                        apiService.createItem(
                            itemNameController.text,
                            double.parse(startingPriceController.text),
                            double.parse(postageCostController.text),
                            double.parse(bidIncrementController.text),
                            conditionOption,
                            endDateTime,
                            acceptReturns,
                            descriptionController.text,
                            accountId!,
                            token!);
                      }
                    },
                    child: const Text('List Item')),
              ],
            ),
          ),
        )));
  }
}
