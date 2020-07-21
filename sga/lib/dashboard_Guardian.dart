import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sga/GuardianPage/StudentProfile.dart';
import 'package:sga/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class dashboard_Guardian extends StatelessWidget {
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
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfilePage(true),)),
            child: CircleAvatar(
              child: Image.asset('assets/images/sga.png'),
              radius: 50,
            ),
          ),
        ),
        Positioned(

          left:125,
          top: 60,
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width*.8,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfilePage(true),)),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kaji Tasnim binte Mohona good",
                        style:
                            TextStyle(fontSize: MediaQuery.of(context).size.width*.042, fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Student Id",
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: MediaQuery.of(context).size.width*.042),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget box(_icon, _text,context) {
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              header(context),
              Container(
                height: 155,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: box(Icons.notifications, 'Notice',context),
                        onTap: () async {
                          SharedPreferences prefs =await SharedPreferences.getInstance();
                          prefs.remove('_userId');
                          prefs.remove('_userType');

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Intropage()));
                        },
                      ),
                    ),
                    Expanded(child: box(Icons.message, 'Messages',context)),
                  ],
                ),
              ),
              Container(
                height: 155,
                child: Row(
                  children: <Widget>[
                    Expanded(child: box(Icons.history, 'Activity',context)),
                    Expanded(child: box(Icons.equalizer, 'Result',context)),
                  ],
                ),
              ),
              Container(
                height: 155,
                child: Row(
                  children: <Widget>[
                    Expanded(child: box(Icons.account_balance, 'Account',context)),
                    Expanded(child: box(Icons.money_off, 'Expense Report',context)),
                  ],
                ),
              ),
              Container(
                height: 155,
                child: Row(
                  children: <Widget>[
                    Expanded(child: InkWell(
                      child: box(Icons.remove, 'Logout',context),
                      onTap: () async {
                        SharedPreferences prefs =await SharedPreferences.getInstance();
                        //await prefs.remove('_userId');
                        await prefs.setString('_userType','T');
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Intropage()));
                      },
                    ),),
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
}
