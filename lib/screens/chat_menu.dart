import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:m_app/Firebase/autth_methods.dart';
import 'package:m_app/screens/chat_screen.dart';
import 'package:m_app/screens/menu_screen.dart';
import "package:m_app/Firebase/firestore.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m_app/constants.dart';

Stream chatRooms;
String loggedInUsername;
String userToMatch;
User loggedInUser;

class ChatMenu extends StatefulWidget {
  static String id = "chat_menu";

  @override
  _ChatMenuState createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> {
  // var pairedUsers = new List();
  // var usersInDb = new Set();

  var firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loggedInUser = getCurrentUser();
    upDateReadytoPair(loggedInUser);
    getChats();
    newUser24hr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: appBarStyleColor,
        title: Text("Chats", style: appBarStyleText),
        actions: [
          IconButton(
              icon: Icon(Icons.info, color: Colors.white),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            "Every 24 hours, we will find you a new user to interact and share your thoughts with."),
                      );
                    });
              })
        ],
      ),
      body: Container(
        decoration: backImage,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: GestureDetector(
                  // onTap: () async {
                  //   SharedPreferences prefs =
                  //       await SharedPreferences.getInstance();
                  //   int currDay = new DateTime.now().day;
                  //   int savedDay = prefs.getInt("lastDay") ?? 0;
                  //   if (currDay != savedDay) {
                  //     await getUserToday();
                  //   }

                  //   print(loggedInUsername);
                  // },
                  child: Card(
                    // color: Color(0xff6ae6dc),
                    // color: Colors.yellow[100],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                          "Please rememeber the  following things when conversing with others \n\u2022 No abusive/Hateful Language.\n\u2022 Be friendly\n\u2022 Keep an open mind \n\u2022 Dont share any personal details"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: chatRoomsList(),
              ),
            ],
          ),
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
                primary: false,
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // loggedInUsername = await getCurrUserName(loggedInUser);
    loggedInUsername = prefs.getString("username");
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

newUser24hr() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int currDay = new DateTime.now().day;
  int savedDay = prefs.getInt("lastDay") ?? 0;
  if (currDay != savedDay) {
    await getUserToday();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInUsername = prefs.getString("username");
    // print(userToMatch);
    String chatRoomId = getChatRoomId(loggedInUsername, userToMatch);
    Map<String, dynamic> chatRoom = {
      "users": [loggedInUsername, userToMatch],
      "chatRoomId": chatRoomId,
      "message_time":DateTime.now().millisecondsSinceEpoch
    };

    addChatRoom(chatRoom, chatRoomId);

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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      chatRoomId: chatRoomId,
                      userName: userName,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.lightBlue[50]
            // color: Colors.lightBlue[50]

            ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(userName.substring(0, 1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w400)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  userName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(
                  top: 1.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
