

class ChatModel {
  final bool isTyping;
  final String lastMessage;
  final String lastMessageTime;
  final String name;

  ChatModel(
      {this.isTyping, this.lastMessage, this.lastMessageTime,this.name});

  static List<ChatModel> list = [
    ChatModel(
      isTyping: true,
      lastMessage: "hello!",
      lastMessageTime: "2d",
      name: 'Bulbul',
    ),
    ChatModel(
      isTyping: false,
      lastMessage: "Sure, no problem Jhon!",
      lastMessageTime: "2d",
      name: 'Kafi',
    ),
  ];
}