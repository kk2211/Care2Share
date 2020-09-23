import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:m_app/Firebase/autth_methods.dart';
import 'package:m_app/screens/menu_screen.dart';
import "package:m_app/Firebase/firestore.dart";

class ChatMenu extends StatefulWidget {
  static String id = "chat_menu";

  User loggedInUser;
  @override
  _ChatMenuState createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> {
  var pairedUsers = new List();
  var usersInDb = new Set();
  final _auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance;
  var userToMatch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loggedInUser = getCurrentUser();
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
                  
                  userToMatch = await getRandomUser(loggedInUser);
                  print(userToMatch);
                  // get  User
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text("Find a user to chat"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
