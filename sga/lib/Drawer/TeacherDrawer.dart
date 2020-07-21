import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sga/TeacherPage/TeacherProfile.dart';

class TeacherDrawer extends StatefulWidget {
  @override
  _TeacherDrawerState createState() => _TeacherDrawerState();
}

class _TeacherDrawerState extends State<TeacherDrawer> {
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
                                child: Icon(Icons.person_outline),
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
                              child: Text("Kaji tasnim binte mohona good girl",style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('student Id')),
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
            onTap: () => print('notice'),
          ),
          ListTile(
            title: Text("Messages"),
            leading: Icon(Icons.message),
            onTap: () => print('message'),
          ),
          ListTile(
            title: Text("Attendance"),
            leading: Icon(Icons.assignment),
            onTap: () => print('Attendance'),
          ),
          ListTile(
            title: Text("Mark Upload"),
            leading: Icon(Icons.equalizer),
            onTap: () => print('Result'),
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.remove),
            onTap: () => print('notice'),
          ),
        ],
      ),
    );
  }
}
