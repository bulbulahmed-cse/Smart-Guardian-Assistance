import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sga/Messenger/ChatList.dart';
import 'package:sga/Notice.dart';
import 'package:sga/TeacherPage/TakeAttendance.dart';
import 'package:sga/TeacherPage/TeacherProfile.dart';
import 'package:sga/TeacherPage/UploadMark.dart';
import 'package:sga/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherDrawer extends StatefulWidget {
  @override
  _TeacherDrawerState createState() => _TeacherDrawerState();
}

class _TeacherDrawerState extends State<TeacherDrawer> {

  var _userName='',_userId='',_userImages='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    __getData();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: InkWell(
                              child: Icon(Icons.keyboard_backspace),
                              onTap: ()=>Navigator.pop(context),
                            )),
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            child: InkWell(
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherProfilePage(true),)),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(_userImages),
                                radius: 50,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 60, left: 10),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherProfilePage(true),)),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(_userName,style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(_userId)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: Text("Notice"),
            leading: Icon(Icons.notifications),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Notice())),
          ),
          ListTile(
            title: Text("Messages"),
            leading: Icon(Icons.message),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatList())),
          ),
          ListTile(
            title: Text("Attendance"),
            leading: Icon(Icons.assignment),
            onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>TakeAttendance())),
          ),
          ListTile(
            title: Text("Mark Upload"),
            leading: Icon(Icons.equalizer),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadMark())),
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.remove),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('_userId');
              await prefs.remove('_userType');
              await prefs.remove('_rememberMe');
              await prefs.remove('_userImages');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Intropage()));
            },
          ),
        ],
      ),
    );
  }

  Future<void> __getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('_userId');
      _userName = prefs.getString('_userName');
      _userImages = prefs.getString('_userImages');
    });

  }
}
