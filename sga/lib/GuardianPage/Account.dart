import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sga/Animation/FadeAnimation.dart';
import 'package:sga/Drawer/GuardianDrawer.dart';
import 'package:sga/Drawer/TeacherDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var accountData, _userType, _userId, _accountNo = '', _amount;
  List<Datas> _datas = [];

  Future _getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('_userType');
    _userId = prefs.getString('_userId');
    print(_userType + _userId);
    var response = await http.post(
        "https://smartguardianassistant.000webhostapp.com/php/account.php",
        body: {
          "userId": _userId,
        });
    setState(() {
      accountData = json.decode(response.body);
      _amount = accountData[0]['amount'];
      _accountNo = accountData[0]['account_no'];
      _getData();
    });
  }

  Future _getData() async {
    var response = await http.post(
        "https://smartguardianassistant.000webhostapp.com/php/account-history.php",
        body: {
          "account_no": _accountNo,
        });
    setState(() {
      accountData = json.decode(response.body);
      print(accountData);
      for (var d in accountData) {
        Datas datas = Datas(
            index: d['no'],
            amount: d['amount'],
            date: d['date'],
            rechargeDetails: d['recharge_details']);
        _datas.add(datas);

        print(datas);
      }
    });

//    var response = await http
////        .get("https://smartguardianassistant.000webhostapp.com/php/notice.php");
////    setState(() {
////      accountData = json.decode(response.body);
////
////      for (var d in accountData){
////        Datas datas= Datas(index: d['no'],noticeName: d['noticeName'],date: d['date']);
////        _datas.add(datas);
////
////        print(datas);
////      }
////    return _datas;
////    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Report'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: Colors.blueAccent,
      ),
      drawer: _userType == 'teacher' ? TeacherDrawer() : GuardianDrawer(),
      body: _accountNo.isEmpty
          ? Container(
              child: Center(
                child: Text("loading..."),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                verticalDirection: VerticalDirection.down,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Student Id:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: _userId,
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                    enabled: false,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Account No:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: _accountNo,
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                    enabled: false,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Total Amount:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: _amount.toString() + 'TK',
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                    enabled: false,

                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'History of Transactions:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataTable(
                    columns: [
                      DataColumn(
                        label: Text("Amount"),
                      ),
                      DataColumn(
                        label: Text("date"),
                      ),
                      DataColumn(
                        label: Text("IN/OUT"),
                      ),
                    ],
                    rows: _datas
                        .map((e) => DataRow(cells: [
                              DataCell(
                                Text(e.amount),
                              ),
                              DataCell(
                                Text(e.date),
                              ),
                              DataCell(
                                Text(e.rechargeDetails),
                              ),
                            ]))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  var data;
  DetailsPage(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["expenseTitle"]),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data['expense_details']),
        ),
      ),
    );
  }
}

class Datas {
  var index;
  var rechargeDetails;
  var amount;
  var date;

  Datas({this.index, this.rechargeDetails, this.amount, this.date});
}
