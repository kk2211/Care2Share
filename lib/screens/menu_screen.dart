import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m_app/Firebase/firestore.dart';
import "package:m_app/components/quotes.dart";
import 'package:m_app/screens/chat_menu.dart';
import 'package:m_app/screens/chatbot.dart';
import 'package:m_app/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:m_app/Firebase/autth_methods.dart";

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class MenuScreen extends StatefulWidget {
  static String id = "menu_screen";
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _auth = FirebaseAuth.instance;
  var quote =
      "Mental health…is not a destination, but a process. It’s about how you drive, not where you’re going";
  @override
  void initState() {
    super.initState();
    displayQuote(DateTime.now()).then((value) {
      setState(() {
        quote = "\"${value}\"";
      });
    });

    loggedInUser = getCurrentUser();
    getCurrUserName(loggedInUser);
  }

  // void getCurrentUser() {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       loggedInUser = user;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              _auth.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("email");
              Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              // Navigator.pushNamed(context, WelcomeScreen.id);
            },
          ),
        ],
        title: Row(
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(minWidth: 10),
                height: 50,
                child: Image.asset(
                  'images/c2s.png',
                ),
              ),
            ),
            Text(
              "Care2Share",
              style: TextStyle(),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        // Choose either column or List View
        child: ListView(
          children: [
            SizedBox(
              height: data.size.height / 30,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.tealAccent,
              elevation: 5,
              child: Row(
                children: [
                  // Flexible(
                  //   child: Container(
                  //     constraints: BoxConstraints(minWidth: 300),
                  //     height: data.size.height/6,
                  //     // child: Image.asset(
                  //     //   'images/c2s.png',
                  //     // ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Sharing your thoughts and feelings can go \na long way in helping you feel better\nabout yourself   ",
                      style: GoogleFonts.archivo(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: data.size.height / 10,
            ),
            Container(
                height: data.size.height / 5,
                child: Scrollbar(
                  child: ListView(
                    children: [
                      Text(
                        " Quote of The Day",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 150),
                          decoration: BoxDecoration(
                              color: Colors.limeAccent,
                              border: Border.all(
                                color: Colors.lightGreen,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular((15)))),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            quote,
                            // "Flutter’s widgets incorporate all critical platform differences such as scrolling, navigation, icons and fonts, and your Flutter code is compiled to native ARM machine code using Dart's native compilers.",

                            style: TextStyle(
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: data.size.height / 25,
            ),
            Flexible(
              child: Container(
                height: data.size.height / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 200,
                      width: 150,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ChatMenu.id);
                        },
                        child: CardBox(
                          text: "Chats",
                          function: "Interact with other people using the app",
                          // function: "",
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 150,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ChatBot.id);
                        },
                        child: CardBox(
                          text: "ChatBot",
                          function: "Interact with our custom made chatbot",
                          // function: "",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  CardBox({this.text, this.function});
  final String text;
  final String function;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.tealAccent,
      elevation: 25,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                function,
                style: TextStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
