import 'package:flutter/material.dart';
import 'package:sga/Drawer/GuardianDrawer.dart';
import 'package:sga/Drawer/TeacherDrawer.dart';
import 'package:sga/Messenger/ChatRoom.dart';
import 'package:sga/Messenger/StudentList.dart';
import 'package:sga/Messenger/TeacherList.dart';
import 'package:sga/Messenger/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatModel> list = ChatModel.list;
  var _userType='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("ChatList"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Teacher"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Student"),
                ),
              ],
            ),
            title: Text("Messenger"),
          ),
          drawer: _userType == 'teacher' ? TeacherDrawer() : GuardianDrawer(),
          body: TabBarView(
            children: [
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white38,
                        ),
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatItemPage(),
                              ),
                            );
                          },
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              image: DecorationImage(
                                image: ExactAssetImage("assets/images/sga.png"),
                              ),
                            ),
                          ),
                          title: Text(
                            list[index].name,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text(
                                list[index].lastMessage,
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(width: 25),
                              Text(
                                list[index].lastMessageTime + " days ago",
                                style: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              TeacherList(),
              StudentList(),
            ],
          ),
        ),
      ),
    );
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('_userType');
    print(_userType);
  }
}
