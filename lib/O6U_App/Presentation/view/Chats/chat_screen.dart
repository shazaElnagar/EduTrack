import 'package:flutter/material.dart';
import 'dart:math';



// Chats List Screen with Search
class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final List<String> randomNames = [
    "Toka Mohamed", "Ali Hassan", "Sarah Ahmed", "Mohamed Adel", "Laila Youssef",
    "Omar Khaled", "Nour Tamer", "Hana Samir", "Kareem Salah", "Mona Ibrahim",
    "Youssef Omar", "Aya Mahmoud", "Malak Sherif", "Ahmed Gamal",
  ];

  final List<String> randomMessages = [
    "See you soon!", "Where are you?", "Let's meet at 5 PM.", "You: Coming immediately!",
    "Call me please.", "On my way!", "Done with the task!", "Can we reschedule?",
    "Good morning!", "Don't forget the meeting.", "Sure, no problem!", "Waiting for you!",
  ];

  final List<String> randomTimes = [
    "12:30 PM", "8:15 AM", "Yesterday", "2 days ago", "Mon", "Sun", "1:00 PM", "5:45 PM",
  ];

  final List<Color> profileColors = [
    Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple,
    Colors.brown, Colors.teal, Colors.pink, Colors.indigo,
  ];

  final Random random = Random();
  List<Map<String, dynamic>> allChats = [];
  List<Map<String, dynamic>> filteredChats = [];

  @override
  void initState() {
    super.initState();
    allChats = List.generate(
      10,
          (index) => {
        "name": randomNames[random.nextInt(randomNames.length)],
        "lastMessage": randomMessages[random.nextInt(randomMessages.length)],
        "time": randomTimes[random.nextInt(randomTimes.length)],
        "color": profileColors[random.nextInt(profileColors.length)],
      },
    );
    filteredChats = allChats;
  }

  void searchChats(String query) {
    final results = allChats.where((chat) {
      final nameLower = chat["name"].toString().toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      filteredChats = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005B7F),
        elevation: 0,

        centerTitle: true,
        title: Text(
          'Chats',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatSearchDelegate(allChats),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: filteredChats.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final chat = filteredChats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: chat["color"],
              child: Text(
                chat["name"].toString().substring(0, 1),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              chat["name"],
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              chat["lastMessage"],
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              chat["time"],
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(name: chat["name"]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Chat Search Delegate
class ChatSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> chats;

  ChatSearchDelegate(this.chats);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = chats.where((chat) {
      final nameLower = chat["name"].toString().toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final chat = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: chat["color"],
            child: Text(
              chat["name"].toString().substring(0, 1),
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(chat["name"]),
          subtitle: Text(chat["lastMessage"]),
          trailing: Text(chat["time"]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(name: chat["name"]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

// Chat Detail Screen with Auto-Reply
class ChatDetailScreen extends StatefulWidget {
  final String name;

  ChatDetailScreen({required this.name});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<Map<String, dynamic>> messages = [
    {"text": "Hello!", "isMe": false},
    {"text": "Hi, how are you?", "isMe": true},
    {"text": "I'm good, thanks!", "isMe": false},
  ];

  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005B7F),
        title: Text(widget.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message["isMe"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: message["isMe"]
                          ? Colors.orangeAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message["text"],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.orange),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "text": messageController.text.trim(),
        "isMe": true,
      });
      messageController.clear();
    });

    scrollToBottom();

    // Auto reply after 1 second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        messages.add({
          "text": getRandomReply(),
          "isMe": false,
        });
      });
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  String getRandomReply() {
    List<String> fakeReplies = [
      "Got it!",
      "I'll get back to you.",
      "Haha, okay!",
      "Interesting...",
      "Sure thing!",
      "Let's do it!",
      "Can you explain more?",
      "That's awesome!",
      "Good idea!",
      "Thanks!",
    ];
    final random = Random();
    return fakeReplies[random.nextInt(fakeReplies.length)];
  }
}