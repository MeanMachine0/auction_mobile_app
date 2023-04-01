import 'package:flutter/material.dart';

import 'package:auction_mobile_app/models/ended_items_model.dart';
import 'package:auction_mobile_app/pages/ended_item_detail.dart';
import 'package:auction_mobile_app/services/api_service.dart';
import 'package:auction_mobile_app/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<EndedItemsModel>? _EndedItemsModel = [];
  late List<String>? _IdToken = [];
  late int? userId = 0;
  late String? token = '';
  late String? username = '';
  late String? password = '';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    token = prefs.getString('token');
    username = prefs.getString('username');
    password = prefs.getString('password');
    ApiService apiService = ApiService();
    _EndedItemsModel = await apiService.getEndedItems();
    setState(() {});
  }

  void _logout() {
    if (token != null) {
      ApiService().logout(token);
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recently Sold Items')),
      body: _EndedItemsModel == null || _EndedItemsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colours.lightGray,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ListView.builder(
                      itemCount:
                          _EndedItemsModel!.where((item) => item.sold).length,
                      itemBuilder: (context, index) {
                        EndedItemsModel item = _EndedItemsModel!
                            .where((item) => item.sold)
                            .toList()[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 2,
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (states) => Colours.darkGray,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    EndedItemDetail(endedItemId: item.id),
                              ));
                            },
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${item.name} - £${item.salePrice.toString()}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colours.lightGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                      onPressed: () => _logout(), child: const Text('Logout')),
                )
              ],
            ),
    );
  }
}
