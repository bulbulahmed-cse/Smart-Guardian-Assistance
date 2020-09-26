import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sga/Animation/FadeAnimation.dart';
import 'package:sga/Drawer/GuardianDrawer.dart';
import 'package:sga/Drawer/TeacherDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseReport extends StatefulWidget {
  @override
  _ExpenseReportState createState() => _ExpenseReportState();
}

class _ExpenseReportState extends State<ExpenseReport> {
  var expenseData, _userType, _userId;

  Future _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('_userType');
    _userId = prefs.getString('_userId');
    print(_userType + _userId);
    var response = await http.post(
        "https://smartguardianassistant.000webhostapp.com/php/expense-report.php",
        body: {
          "userId": _userId,
        });
    setState(() {
      expenseData = json.decode(response.body);
      print(expenseData);
    });
    return expenseData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments Report'),
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
      body: Container(
        child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeAnimation(
                    1.4,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(snapshot.data[index]["expenseTitle"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(snapshot.data[index]["date_time"]),
                              Text(snapshot.data[index]["amount"] + "Tk",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsPage(snapshot.data[index])));
                          },
                          leading: CircleAvatar(backgroundColor: Colors.white60,
                            child: Image.asset("assets/images/sga.png"),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
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
