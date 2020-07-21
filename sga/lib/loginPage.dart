
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sga/Animation/FadeAnimation.dart';
import 'package:sga/dashboard_Guardian.dart';
import 'package:sga/dashboard_Teacher.dart';
import 'package:sga/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userId = '', _password = '';
  var _userIdDb='bulbul8167',_passwordDb='123456',_userType='G';

  bool _rememberMe = false;





  Widget _loginButton(){

    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          _logIn();
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blueAccent,
        child: Text(
          "Login",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[100]))),
      child: TextField(
        obscureText: true,
        onChanged: (input) => _password = input,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.lock),
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _userTextField() {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[100]))),
      child: TextField(
        onChanged: (input) => _userId = input,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.email),
            hintText: "User Id",
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget _forgotButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('press Forgot Button?'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _rememberMeCheckBox() {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _rememberMe,
            checkColor: Colors.black,
            activeColor: Colors.blueAccent,
            onChanged: (value) {
              setState(() {
                _rememberMe = value;
              });
            },
          ),
          Text('Remember Me'),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(60),bottomLeft: Radius.circular(60)),
                      color: Colors.blueAccent,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: FadeAnimation(
                          0.6,
                          Container(
                            margin: EdgeInsets.only(top: 50.0),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  blurRadius: 20.0,
                                )
                              ]),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(0.8, _userTextField()),
                              SizedBox(
                                height: 2,
                              ),
                              FadeAnimation(1, _passwordTextField()),
                            ],
                          ),
                        ),
                        //FadeAnimation(1, _forgotButton()),
                        FadeAnimation(1.2, _rememberMeCheckBox()),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          1.4,
                          _loginButton(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to exit the app"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      ),
    );
  }

  void _logIn() async {

    


    if(_userId==_userIdDb && _password==_passwordDb){

      if(_userType=='G'){
        __rememberMe();
        print('Guardian');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>dashboard_Guardian()));
      }else if(_userType=='T'){
        __rememberMe();
        print('Teacher');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>dashboard_Teacher()));
      }
    }else{
      Fluttertoast.showToast(
          msg: "User Id or Password incorrect",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
  }

   Future<bool> __rememberMe() async {
    if(_rememberMe==true){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('_userId', _userId);
      await prefs.setString('_userType',_userType);
      return true;
    }else return false;
  }

}



