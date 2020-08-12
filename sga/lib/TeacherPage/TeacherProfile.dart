import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sga/Drawer/TeacherDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherProfilePage extends StatefulWidget {
  bool _state;
  TeacherProfilePage(_State) {
    this._state = _State;
  }
  @override
  _TeacherProfilePageState createState() => _TeacherProfilePageState(_state);
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  bool _state = false, _statePage;

  var _teacherName = '',
      _teacherId = '',
      _teacherEmail = '',
      _sex = '',
      _teacherFatherName = '',
      _teacherMotherName = '',
      _blood = '',
      _phone = '',
      _teacherAddress = '',
      _teacherImage = '';
  _TeacherProfilePageState(_state) {
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
              backgroundImage: NetworkImage(_teacherImage),
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.blueAccent,
        ),
        drawer: TeacherDrawer(),
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
                _textField("Name: ", _teacherName, false),
                _textField("Id: ", _teacherId, false),
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
                                'Email:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            TextField(
                              onChanged: (input) => _teacherEmail = input,
                              autofocus: _state,
                              decoration: InputDecoration(
                                hintText: _state ? '' : _teacherEmail,
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
                _textField("Father Name: ", _teacherFatherName, false),
                _textField("Mother Name: ", _teacherMotherName, false),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _textField("Sex: ", _sex, false),
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
                                      style: TextStyle(fontWeight: FontWeight.bold),
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
                                'Phone:',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                              onChanged: (input) => _teacherAddress = input,
                              autofocus: _state,
                              decoration: InputDecoration(
                                hintText: _state ? '' : _teacherAddress,
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
      _teacherId = prefs.getString('_userId');
      final response = await http.post(
          "https://smartguardianassistant.000webhostapp.com/php/teacher-profile-data.php",
          body: {
            "userId": _teacherId,
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
          _teacherId = data[0]['teacher_id'];
          _teacherName = data[0]['name'];
          _teacherFatherName = data[0]['fatherName'];
          _teacherMotherName = data[0]['motherName'];
          _teacherEmail = data[0]['email'];
          _sex = data[0]['sex'];
          _blood = data[0]['blood'];
          _phone = data[0]['phone'];
          _teacherAddress = data[0]['address'];
          _teacherImage = data[0]['image'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> __update() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _teacherId = prefs.getString('_userId');
      final response = await http.post(
          "https://smartguardianassistant.000webhostapp.com/php/teacher-profile-update.php",
          body: {
            "_teacherId": _teacherId,
            "_teacherAddress": _teacherAddress,
            "_blood": _blood,
            "_phone": _phone,
            "_email": _teacherEmail,
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
