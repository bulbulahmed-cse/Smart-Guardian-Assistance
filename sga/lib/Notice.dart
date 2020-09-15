import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sga/Animation/FadeAnimation.dart';
import 'package:sga/Drawer/GuardianDrawer.dart';
import 'package:sga/Drawer/TeacherDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  var noticeData, _userType='';
  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('_userType');
    print(_userType);
  }
  Future _getData() async {
    var response = await http
        .get("https://smartguardianassistant.000webhostapp.com/php/notice.php");
    setState(() {
      noticeData = json.decode(response.body);
     // print(noticeData);
    });
    return noticeData;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice'),
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
      drawer:_userType == 'teacher' ? TeacherDrawer() : GuardianDrawer(),
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
                  return FadeAnimation(1.4,
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(snapshot.data[index]["noticeName"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          subtitle: Text(snapshot.data[index]["date"]),
                          onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(snapshot.data[index])));},
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
        title: Text(data["noticeName"]),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data['description']),
        ),
      ),

    );
  }
}
