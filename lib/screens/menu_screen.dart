import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:m_app/components/quotes.dart";
import 'package:m_app/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent[100],
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
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
          ),
        ],
        title: Text(
          "Care2Share",
          style: TextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(minWidth: 300),
                    height: 150,
                    child: Image.asset(
                      'images/c2s.png',
                    ),
                  ),
                ),
                Text(
                  "Sharing your thoughts and feelings can \ngo a long way in helping you feel better\nabout yourself   ",
                  style: GoogleFonts.archivo(
                      textStyle: TextStyle(color: Colors.black, fontSize: 15)),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              " Quote of The Day",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.limeAccent,
                    border: Border.all(
                      color: Colors.lightGreen,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular((30)))),
                padding: EdgeInsets.all(20),
                child: Text(
                  quote,
                  style: TextStyle(
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 200,
                  width: 150,
                  child: GestureDetector(
                    child: CardBox(text:"Chat Screen"),
                  ),
                ),
                
                Container(
                  height: 200,
                  width: 150,
                  child: GestureDetector(
                    child: CardBox(text:"ChatBot"),
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  CardBox({this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only( top: 20),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Text(
              text
            ),
          ],
        ),
      ),
    );
  }
}
