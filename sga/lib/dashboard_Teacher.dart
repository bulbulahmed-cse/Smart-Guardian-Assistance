import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sga/Notice.dart';
import 'package:sga/TeacherPage/TeacherProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Dashboard_Teacher extends StatefulWidget {
  @override
  _Dashboard_TeacherState createState() => _Dashboard_TeacherState();
}

class _Dashboard_TeacherState extends State<Dashboard_Teacher> {
  var _userName='',_userId='',_userImages='';
  bool isLoading=true;



  Widget header(context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 180,
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
        ),
        Positioned(
          left: 15,
          top: 45,
          child: InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherProfilePage(true),)),
            child: CircleAvatar(
              backgroundImage: NetworkImage(_userImages),
              radius: 50,
            ),
          ),
        ),
        Positioned(
          left: 125,
          top: 60,
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width * .8,
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherProfilePage(true),)),
                      child: Text(
                        _userName,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .042,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                SizedBox(
                  height: 2,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _userId,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: MediaQuery.of(context).size.width * .042),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget box(_icon, _text, context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Positioned(
            top: 20,
            child: CircleAvatar(
              child: Icon(
                _icon,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
              radius: 30,
            ),
          ),
          Positioned(
              top: 90,
              child: Container(
                child: Text(
                  _text,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    __getData();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:isLoading?Center(child: CircularProgressIndicator()):SingleChildScrollView(
          child: Column(
            children: <Widget>[
              header(context),
              Container(
                height: 155,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: box(Icons.notifications, 'Notice', context),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Notice()));

                        },
                      ),
                    ),
                    Expanded(child: box(Icons.message, 'Messages', context)),
                  ],
                ),
              ),
              Container(
                height: 155,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: box(Icons.equalizer, 'Upload Mark', context)),
                    Expanded(
                        child: box(Icons.assignment, 'Attendance', context)),
                  ],
                ),
              ),
              Container(
                height: 155,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: box(Icons.remove, 'Logout', context),
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.remove('_userId');
                          await prefs.remove('_userType');
                          await prefs.remove('_rememberMe');
                          await prefs.remove('_userImages');
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Intropage()));
                        },
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  __getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('_userId');
    try {
      final response =
      await http.post(
          "https://smartguardianassistant.000webhostapp.com/php/teacher-profile-data.php",
          body: {
            "userId": _userId,
          });
      if (response.body.length == 0) {
        Fluttertoast.showToast(
            msg: "Error",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        var data = jsonDecode(response.body);
        setState(() {
          _userName = data[0]['name'];
          _userImages = data[0]['image'];
          isLoading=false;

        });

      }
    }catch(e){
      print(e);
    }
    await prefs.setString('_userName', _userName);
    await prefs.setString('_userImages', _userImages);
  }
}
