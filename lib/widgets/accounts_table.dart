import 'package:flutter/material.dart';

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        title: const Text('Recently Sold Items'),
        backgroundColor: Colours.lightBlue),
    body: _accountsModel == null || _accountsModel!.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Balance (£)')),
                  DataColumn(label: Text('Address')),
                ],
                rows: _accountsModel!
                    .map(
                      (account) => DataRow(
                        cells: [
                          DataCell(Text(account.id.toString())),
                          DataCell(Text(account.user)),
                          DataCell(Text(account.balance.toString())),
                          DataCell(Text(account.address)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
  );
}

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
