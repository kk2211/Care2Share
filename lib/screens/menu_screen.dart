import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m_app/Firebase/firestore.dart';
import 'package:m_app/MoodDiary/models/moodcard.dart';
import 'package:m_app/MoodDiary/screens/start.dart';
import "package:m_app/components/quotes.dart";
import 'package:m_app/constants.dart';
import 'package:m_app/screens/chat_menu.dart';
import 'package:m_app/screens/chatbot.dart';
import 'package:m_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:m_app/Firebase/autth_methods.dart";
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
String loggedInUsername;

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
    // getCurrUserName(loggedInUser);
    // getLoggedInUsername();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    getLoggedInUsername();
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          color: Colors.lightGreen[100],
          child: ListView(
            children: [
              Expanded(
                child: new DrawerHeader(
                  decoration: BoxDecoration(color: Colors.green[200]),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                          child: Text(loggedInUsername.substring(0, 1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontFamily: 'OverpassRegular',
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Welcome ${loggedInUsername}"),
                    ],
                  ),
                ),
              ),
              FlatButton(
                  onPressed: () {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                "Connect To Vandrevala Foundation Helpline Number"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("No")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    const url = 'tel://+917304599836';
                                    UrlLauncher.launch(url);
                                  },
                                  child: Text("Yes"))
                            ],
                          );
                        });
                  },
                  child: Text("Need Help")),
              FlatButton(
                  onPressed: () async {
                    _auth.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove("email");
                    prefs.remove("username");
                    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                    // Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                  child: Text("Logout"))
            ],
          ),
        ),
      ),
      // backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: null,

        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.exit_to_app,
        //       color: Colors.white,
        //     ),
        //     onPressed: () async {
        //       _auth.signOut();
        //       SharedPreferences prefs = await SharedPreferences.getInstance();
        //       prefs.remove("email");
        //       Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        //       // Navigator.pushNamed(context, WelcomeScreen.id);
        //     },
        //   ),
        // ],
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
            Text("Care2Share", style: appBarStyleText),
          ],
        ),
      ),

      body: Container(
        decoration: backImage,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 1.0, top: 20),
          // Choose either column or List View
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              // SizedBox(
              //   height: data.size.height / 30,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30),
                child: Card(
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
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: Text(
                      //     "Sharing your thoughts and feelings can go \na long way in helping you feel better\nabout yourself   ",
                      //     style: GoogleFonts.archivo(
                      //         textStyle:
                      //             TextStyle(color: Colors.black, fontSize: 15)),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: data.size.height / 20,
              ),
              Container(

                  // height: data.size.height / 5,
                  child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular((15)))),
                    child: Text(
                      " Quote of the Day",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      // constraints: BoxConstraints(maxHeight: 150),
                      decoration: BoxDecoration(
                          // color: Colors.lightBlue[50],
                          border: Border.all(
                            color: Colors.green,
                          ),
                          borderRadius:
                              BorderRadius.all(Radius.circular((15)))),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        quote,
                        // "Flutter’s widgets incorporate all critical platform differences such as scrolling, navigation, icons and fonts, and your Flutter code is compiled to native ARM machine code using Dart's native compilers.",

                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              )),
              SizedBox(
                height: data.size.height / 25,
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: FeatureRow(data: data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  const FeatureRow({
    Key key,
    @required this.data,
  }) : super(key: key);

  final MediaQueryData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // height: 200,
            width: data.size.width / 1.1,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ChatMenu.id);
              },
              child: CardBox(
                text: "Chats",
                function: "Connect with other people using the app",
                // function: "",
              ),
            ),
          ),
          Container(
            // height: 200,
            width: data.size.width / 1.1,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ChatBot.id);
              },
              child: CardBox(
                text: "ChatBot",
                function: "Use our custom made chatbot",
                // function: "",
              ),
            ),
          ),
          Container(
            // height: 200,
            width: data.size.width / 1.1,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, StartPage.id);
              },
              child: CardBox(
                text: "Mood Diary",
                function: "Keep Track of your moods",
                // function: "",
              ),
            ),
          ),
        ],
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
      color: Colors.lightGreen[100],
      // color: Colors.yellowAccent[100],
      elevation: 50,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 1),
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

getLoggedInUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  loggedInUsername = prefs.getString("username");
}
