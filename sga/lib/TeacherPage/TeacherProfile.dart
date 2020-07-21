import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sga/Drawer/TeacherDrawer.dart';

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
  _TeacherProfilePageState(_state) {
    this._statePage = _state;
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
              child: Icon(Icons.person),
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
                    hintText: _enable?'':_textHint,
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

  Widget _getButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: (){
                    setState(() {
                      _state=false;
                      _statePage=true;
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
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),

                ),
              )
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: (){
                    setState(() {
                      _state=false;
                      _statePage=true;
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
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),

                ),
              )
          ),



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
                        _statePage=false;
                      });
                    },
                  ):Icon(Icons.arrow_downward),

                ),
                _textField("Name: ", 'name', false),
                _textField("Id: ", 'Id', false),
                _textField("Email ", 'Email', _state),
                _textField("Father Name: ", 'Father name', false),
                _textField("Mother Name: ", 'Mother name', false),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: _textField(
                          "Sex: ", 'Sex', _state),
                    ),
                    Expanded(
                      child: _textField(
                          "Blood:", 'Blood', _state),
                    ),


                  ],
                ),
                _textField("Phone: ", 'Phone',_state),
                _textField("Address: ", 'Address',_state),
                SizedBox(
                  height: 10,
                ),
                _state?_getButton():Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}