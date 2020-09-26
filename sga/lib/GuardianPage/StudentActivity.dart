import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sga/Drawer/GuardianDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentActivity extends StatefulWidget {
  @override
  _StudentActivityState createState() => _StudentActivityState();
}

class _StudentActivityState extends State<StudentActivity> {
  DateTime selectedDate = DateTime.now();
  var accountData, _userType, _userId, _class;
  bool _isLoading = true, _isLoadingTable = true;

  List<Datas> _datas = [];

  Widget textItem(_name, _hint, _enable) {
    return Padding(
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
                        _name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    TextFormField(
                      readOnly: true,
                      initialValue: _hint,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _class = value;
                        });
                      },
                      enabled: _enable,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('_userType');
    _userId = prefs.getString('_userId');
    print(_userType + _userId);
    var response = await http.post(
        "https://smartguardianassistant.000webhostapp.com/php/studentprofiledata.php",
        body: {
          "userId": _userId,
        });
    setState(() {
      accountData = json.decode(response.body);
      setState(() {
        _class = accountData[0]['class'];
        _isLoading = false;
      });
      _getHistory();
    });
  }

  Future _getHistory() async {
    var response = await http.post(
        "https://smartguardianassistant.000webhostapp.com/php/attendance.php",
        body: {
          "userId": _userId,
          "class": _class,
          "date": "${selectedDate.toLocal()}".split(' ')[0],
        });
    print(response.body);

    try {
      setState(() {
        accountData = json.decode(response.body);
        print(accountData);
        _datas.clear();
        for (var d in accountData) {
          Datas datas = Datas(
              index: d['no'],
              subject: d['subject'],
              time: d['time'],
              attendance: d['attendance']);
          _datas.add(datas);
          _isLoadingTable = false;

          print(datas);
        }

      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Have no Data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Activity'),
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
      drawer: GuardianDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                verticalDirection: VerticalDirection.down,
                children: [
                  textItem('Student Id : ', _userId, false),
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
                                      "Class : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blueGrey,
                                    ),
                                    child: DropdownButton<String>(
                                      value: _class,
                                      icon: Icon(
                                        Icons.arrow_downward,
                                        color: Colors.black,
                                      ),
                                      dropdownColor: Colors.blueGrey,
                                      iconSize: 24,
                                      elevation: 16,
                                      underline: Container(
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                      isExpanded: true,
                                      style: TextStyle(color: Colors.black),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _class = newValue;
                                        });
                                      },
                                      items: <String>['06', '07', '08', '09','10','11','12']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
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
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  'Date :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text(
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 4,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: IconButton(
                                        onPressed: () {
                                          _getHistory();
                                          setState(() {
                                            _isLoadingTable = true;
                                          });
                                        },
                                        icon: Icon(Icons.search),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                    'Attendance:',
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
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: _isLoadingTable
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        : DataTable(
                            columns: [
                              DataColumn(
                                label: Text("Subject"),
                              ),
                              DataColumn(
                                label: Text("Time"),
                              ),
                              DataColumn(
                                label: Text("Attendance"),
                              ),
                            ],
                            rows: _datas
                                .map((e) => DataRow(cells: [
                                      DataCell(
                                        Text(e.subject),
                                      ),
                                      DataCell(
                                        Text(e.time),
                                      ),
                                      DataCell(
                                        Text(e.attendance),
                                      ),
                                    ]))
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}


class Datas {
  var index;
  var subject;
  var time;
  var attendance;

  Datas({this.index, this.subject, this.time, this.attendance});
}
