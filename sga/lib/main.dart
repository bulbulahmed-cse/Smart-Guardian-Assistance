import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sga/Animation/FadeAnimation.dart';
import 'package:sga/dashboard_Guardian.dart';
import 'package:sga/dashboard_Teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'loginPage.dart';

void main() {
  runApp(MultiProvider(
      child: MaterialApp(
        title: 'SGA',
        debugShowCheckedModeBanner: false,
        home: Intropage(),
      )));
}

class Intropage extends StatefulWidget {
  @override
  _IntropageState createState() => _IntropageState();
}

class _IntropageState extends State<Intropage> {
  var _userPref, _userTypePref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _userPref = prefs.getBool('_rememberMe');
      _userTypePref = prefs.getString('_userType');

      if (_userPref == true) {
        if (_userTypePref == 'student') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Dashboard_Guardian()));
        } else if (_userTypePref == 'teacher') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Dashboard_Teacher()));
        }
      } else
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FadeAnimation(
      0.8,
      Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Image.asset("assets/images/sga.png"),
        ),
      ),
    ));
  }
}
