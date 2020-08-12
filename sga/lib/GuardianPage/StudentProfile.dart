import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sga/Drawer/GuardianDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfilePage extends StatefulWidget {
  bool _state; //For Editing option
  StudentProfilePage(_State) {
    this._state = _State;
  }
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState(_state);
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  var _studentName = '',
      _studentId = '',
      _studentFatherName = '',
      _studentMotherName = '',
      _studentFatherPhone = '',
      _studentMotherPhone = '',
      _class = '',
      _rollNo = '',
      _group = '',
      _sex = '',
      _blood = '',
      _phone = '',
      _studentAddress = '',
      _studentImage = '';

  bool _state = false, _statePage;
  _StudentProfilePageState(_state) {
    this._statePage = _state;
    __getData();
  }

  Widget _userImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(_studentImage),
              radius: 80,
            ),
            Positioned(
              bottom: 10,
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                radius: 25,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(_textTitle, _textHint, _enable) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    _textTitle,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                TextField(
                  autofocus: _enable,
                  decoration: InputDecoration(
                    hintText: _enable ? '' : _textHint,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  enabled: _enable,
                )
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }

  Widget _getButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                __update();
                setState(() {
                  _state = false;
                  _statePage = true;
                });
              },
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.blueAccent,
              child: Text(
                "Save",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  _state = false;
                  _statePage = true;
                });
              },
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.red,
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          )),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.blueAccent,
        ),
        drawer: GuardianDrawer(),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                _userImage(),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  title: Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: _statePage
                      ? InkWell(
                          child: CircleAvatar(
                            child: Icon(Icons.edit),
                            radius: 15,
                          ),
                          onTap: () {
                            setState(() {
                              _state = true;
                              _statePage = false;
                            });
                          },
                        )
                      : Icon(Icons.arrow_downward),
                ),
                _textField("Name: ", _studentName, false),
                _textField("Id: ", _studentId, false),
                _textField("Father Name: ", _studentFatherName, false),
                _textField("Mother Name: ", _studentMotherName, false),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _textField(
                          "Father Phone: ", _studentFatherPhone, false),
                    ),
                    Expanded(
                      child: _textField(
                          "Mother Phone: ", _studentMotherPhone, false),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _textField("Class: ", _class, false),
                    ),
                    Expanded(
                      child: _textField("Roll No:", _rollNo, false),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Group:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  TextField(
                                    onChanged: (input) => _group = input,
                                    autofocus: _state,
                                    decoration: InputDecoration(
                                      hintText: _state ? '' : _group,
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                    enabled: _state,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: _textField("Sex:", _sex, false),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Student Phone:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  TextField(
                                    onChanged: (input) => _phone = input,
                                    autofocus: _state,
                                    decoration: InputDecoration(
                                      hintText: _state ? '' : _phone,
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                    enabled: _state,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Blood:',
                                      style: TextStyle(

                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  TextField(
                                    onChanged: (input) => _blood = input,
                                    autofocus: _state,
                                    decoration: InputDecoration(
                                      hintText: _state ? '' : _blood,
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                    enabled: _state,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Address:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            TextField(
                              onChanged: (input) => _studentAddress = input,
                              autofocus: _state,
                              decoration: InputDecoration(
                                hintText: _state ? '' : _studentAddress,
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              enabled: _state,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _state ? _getButton() : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }

  __getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _studentId = prefs.getString('_userId');
      final response = await http.post(
          "https://smartguardianassistant.000webhostapp.com/php/studentprofiledata.php",
          body: {
            "userId": _studentId,
          });
      if (response.body.length == 0) {
        Fluttertoast.showToast(
            msg: "Loading...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        var data = jsonDecode(response.body);
        setState(() {
          _studentId = data[0]['student_id'];
          _studentName = data[0]['student_name'];
          _studentFatherName = data[0]['fatherName'];
          _studentMotherName = data[0]['motherName'];
          _studentFatherPhone = data[0]['fatherPhone'];
          _studentMotherPhone = data[0]['motherphone'];
          _class = data[0]['class'];
          _rollNo = data[0]['class_roll'];
          _group = data[0]['group'];
          _sex = data[0]['sex'];
          _blood = data[0]['blood'];
          _phone = data[0]['studentPhone'];
          _studentAddress = data[0]['student_address'];
          _studentImage = data[0]['image'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> __update() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _studentId = prefs.getString('_userId');
      final response = await http.post(
          "https://smartguardianassistant.000webhostapp.com/php/student-profile-update.php",
          body: {
            "_studentId": _studentId,
            "_group": _group,
            "_studentAddress": _studentAddress,
            "_blood": _blood,
            "_phone": _phone,
          });
      print(response.body);
      Fluttertoast.showToast(
          msg: response.body,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e);
    }
  }
}
