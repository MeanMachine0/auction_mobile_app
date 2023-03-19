import 'package:flutter/material.dart';
import 'package:my_rest_api/models/accounts_model.dart';
import 'package:my_rest_api/pages/my_bids.dart';
import 'package:my_rest_api/services/api_service.dart';
import 'package:my_rest_api/widgets/nav_bar.dart';
import 'package:my_rest_api/pages/browse.dart';
import 'package:my_rest_api/pages/list_an_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<AccountsModel>? _accountsModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _accountsModel = await ApiService().getAccounts();
    setState(() {});
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const Home();
        break;
      case 1:
        page = const Browse();
        break;
      case 2:
        page = const ListAnItem();
        break;
      case 3:
        page = const MyBids();
        break;
      default:
        throw UnimplementedError('No widget for $_selectedIndex');
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction App'),
      ),
      body: _accountsModel == null || _accountsModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _accountsModel!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_accountsModel![index].id.toString()),
                          Text(_accountsModel![index].balance.toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_accountsModel![index].address),
                          Text(_accountsModel![index].user),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigationItemSelected,
      ),
    );
  }
}
