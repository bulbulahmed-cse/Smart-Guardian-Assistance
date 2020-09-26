import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sga/Animation/FadeAnimation.dart';
import 'package:http/http.dart' as http;

class TeacherList extends StatefulWidget {
  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(snapshot.data[index]['name'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        subtitle: Text(snapshot.data[index]['teacher_id']),
                        onTap:(){},
                        leading: CircleAvatar(backgroundColor: Colors.white60,
                          child: Image.asset("assets/images/sga.png"),
                        ),
                      ),
                    ),
                  );
              },
            );
          }
        },
      ),
    );
  }

  Future _getData() async {
    try{
      var response = await http
          .post("https://smartguardianassistant.000webhostapp.com/php/user-info.php",body: {
        "userType":'teacher',
      });
      var data=json.decode(response.body);
      return data;
    }catch(e){
      print('error');
    }

  }
}
