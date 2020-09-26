import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sga/Drawer/TeacherDrawer.dart';
import 'package:http/http.dart' as http;

class TakeAttendance extends StatefulWidget {
  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  DateTime selectedDate = DateTime.now();
  var accountData, _class;
  bool _isLoadingTable = false;

  List _data = List();

  var _subject;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future _getHistory() async {
    _isLoadingTable=true;
    var response = await http.post(
        "https://smartguardianassistant.000webhostapp.com/php/student_list.php",
        body: {
          "class": _class,
          "date": "${selectedDate.toLocal()}".split(' ')[0],
          "subject" : _subject,
        });
    print(response.body);

    try {
      setState(() {
        accountData = json.decode(response.body) as List;
        print(accountData);
        _data.clear();

        for (var d in accountData) {
          if(d['attendance']==null){
            d['attendance']='no';
          }
          print(d['attendance']);
          _data.add(Data.fromJson(d));

        }
        print(_data);

        _isLoadingTable = false;


      });
    } catch (e) {
      toast('Have no data');
    }
  }



  Widget textItem(_name, _hint, _enable) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        _name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    TextFormField(

                      decoration: InputDecoration(
                        hintText: _hint,
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _subject = value;
                        });
                      },
                      enabled: _enable,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Attendance'),
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
      drawer: TeacherDrawer(),
      body:SingleChildScrollView(
        child: Column(
          verticalDirection: VerticalDirection.down,
          children: [
            textItem('Subject ', "Enter Subject Name", true),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Class : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blueGrey,
                              ),
                              child: DropdownButton<String>(
                                value: _class,
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                ),
                                dropdownColor: Colors.blueGrey,
                                iconSize: 24,
                                elevation: 16,
                                underline: Container(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                isExpanded: true,
                                style: TextStyle(color: Colors.black),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _class = newValue;
                                  });
                                },
                                items: <String>['06', '07', '08', '09','10','11','12']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text(
                            'Date :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: ()=>_selectDate(context),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    "${selectedDate.toLocal()}"
                                        .split(' ')[0],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ),
                          flex: 4,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: IconButton(
                                  onPressed: () {
                                    _getHistory();
                                    setState(() {
                                      _isLoadingTable = true;
                                    });
                                  },
                                  icon: Icon(Icons.search),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Attendance:',
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _isLoadingTable
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )
                  : DataTable(

                columns: [
                  DataColumn(
                    label: Text("Student Id"),
                  ),

                ],
                rows: _data
                    .map((e) => DataRow(
                     selected: e.attendance=='yes'?true:false,
                    onSelectChanged: (selected){
                       print(_data.indexOf(e));
                    onSelectedRow(selected,e,_data.indexOf(e));
                    },
                    cells: [
                  DataCell(
                    Text(e.studentId),
                  ),

                ]))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                color: Colors.blueAccent,
                child: Text("Save"),
                onPressed: () async {
                  try{
                    var response = await http.post(
                        "https://smartguardianassistant.000webhostapp.com/php/take_attendance.php",
                        body: {
                    "class": _class,
                    "date": "${selectedDate.toLocal()}".split(' ')[0],
                    "subject" : _subject,
                    "data" : jsonEncode(_data),
                    });
                    toast(response.body);
                  }catch (e){
                    toast('Have no data');
                  }

                },
              ),
            )
          ],
        ),
      ),
    );
  }

  toast(msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void onSelectedRow(bool selected, Data e,index) {
    setState(() {
      if(selected){
        _data[index]=Data(studentId: e.studentId,attendance: 'yes');
       var en= jsonEncode(_data);
       print(en);
      }else{
        _data[index]=Data(studentId: e.studentId,attendance: 'No');
        var en= jsonEncode(_data);
        print(en);
      }
    });
  }
}

class Data {
  String studentId;
  String attendance;

  Data({this.studentId, this.attendance});

  Data.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    attendance = json['attendance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.studentId;
    data['attendance'] = this.attendance;
    return data;
  }

}
