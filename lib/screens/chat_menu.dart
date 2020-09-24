import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:m_app/Firebase/autth_methods.dart';
import 'package:m_app/screens/menu_screen.dart';
import "package:m_app/Firebase/firestore.dart";
import 'package:shared_preferences/shared_preferences.dart';

Stream chatRooms;
String loggedInUsername;
String userToMatch;

class ChatMenu extends StatefulWidget {
  static String id = "chat_menu";

  User loggedInUser;

  @override
  _ChatMenuState createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> {
  var pairedUsers = new List();
  var usersInDb = new Set();

  var firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loggedInUser = getCurrentUser();
    upDateReadytoPair(loggedInUser);
    getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        title: Text("Chat Menu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int currDay = new DateTime.now().day;
                  int savedDay = prefs.getInt("lastDay") ?? 0;
                  if (currDay != savedDay) {
                    await getUserToday();
                  }

                  print(loggedInUsername);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text("Find a user to chat"),
                  ),
                ),
              ),
            ),
            Container(
              child: chatRoomsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                      userName: snapshot.data.documents[index]
                          .get('chatRoomId')
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(loggedInUsername, ""),
                      chatRoomId:
                          snapshot.data.documents[index].get('chatRoomId'));
                })
            : Container();
      },
    );
  }

  getChats() async {
    loggedInUsername = await getCurrUserName(loggedInUser);
    getUserChats(loggedInUsername).then((snapshots) {
      setState(() {
        print("some");
        chatRooms = snapshots;
        print(chatRooms);
        // print(
        //     "we got the data + ${chatRooms.toString()} this is name  ${loggedInUsername}");
      });
    });
  }
}

getChatRoomId(var a, var b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

getUserToday() async {
  userToMatch = await getRandomUser(loggedInUser);
  if (userToMatch != null) {
    loggedInUsername = await getCurrUserName(loggedInUser);
    // print(userToMatch);
    String chatRoomId = getChatRoomId(loggedInUsername, userToMatch);
    Map<String, dynamic> chatRoom = {
      "users": [loggedInUsername, userToMatch],
      "chatRoomId": chatRoomId
    };

    addChatRoom(chatRoom, chatRoomId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("lastDay", DateTime.now().day);
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => null));
      },
      child: Container(
        color: Colors.lightGreen[200],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
