import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sga/Messenger/chat_item_model.dart';
import 'package:sga/Messenger/chat_model.dart';

class ChatItemPage extends StatefulWidget {
  @override
  _ChatItemPageState createState() => _ChatItemPageState();
}

class _ChatItemPageState extends State<ChatItemPage> {

  var _message;
  ChatModel currentChat = ChatModel.list.elementAt(0);
  String currentUser = "1";
  String pairId = "2";
  List<ChatItemModel> chatItems = ChatItemModel.list;
  final TextEditingController _textController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white12,
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "${currentChat.name}",
            ),
            centerTitle: true,
          ),
          body: Scaffold(
            backgroundColor: Colors.white12,
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: chatItems.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: chatItems[index].senderId == currentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: <Widget>[
                            _isFirstMessage(chatItems, index) &&
                                chatItems[index].senderId == pairId
                                ? Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white38,
                                image: DecorationImage(
                                  image: ExactAssetImage(
                                    "assets/images/sga.png",
                                  ),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                            )
                                : Container(
                              width: 30,
                              height: 30,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * .7,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(
                                    _isFirstMessage(chatItems, index) ? 0 : 10,
                                  ),
                                  bottomLeft: Radius.circular(
                                    _isLastMessage(chatItems, index) ? 0 : 10,
                                  ),
                                ),
                                color: chatItems[index].senderId == currentUser
                                    ? Colors.blueAccent
                                    : Colors.white38,
                              ),
                              child: Text(
                                "${chatItems[index].message}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
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
            bottomNavigationBar: _buildInput(),

          ),


    );
  }

  Widget _buildInput() {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              style: TextStyle(color: Colors.white),
              onChanged: (value){
                _message=value;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type something...",
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          IconButton(
            icon: CircleAvatar(
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
            onPressed: (){
              if(_message!=null){
                setState(() {
                  ChatItemModel.list.insert(0,ChatItemModel(message: _message,senderId: currentUser));
                  _textController.clear();
                  _message=null;
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                });
              }
            },
          ),
        ],
      ),
    );
  }

  _isFirstMessage(List<ChatItemModel> chatItems, int index) {
    return (chatItems[index].senderId !=
        chatItems[index - 1 < 0 ? 0 : index - 1].senderId) ||
        index == 0;
  }

  _isLastMessage(List<ChatItemModel> chatItems, int index) {
    int maxItem = chatItems.length - 1;
    return (chatItems[index].senderId !=
        chatItems[index + 1 > maxItem ? maxItem : index + 1].senderId) ||
        index == maxItem;
  }
}