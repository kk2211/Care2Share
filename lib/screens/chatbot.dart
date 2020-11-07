import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m_app/Firebase/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m_app/Firebase/autth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m_app/components/bot.dart';
import 'package:m_app/components/messageBubble.dart';
import 'package:m_app/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String loggedInUserName;
User loggedInUser;
// List<String> topics = [
//   "depression",
//   "anxiety",
//   "self-esteem",
//   "trauma",
//   "anger-mangement",
//   "stress",
//   "relationships",
//   "addiction"
// ];

class ChatBot extends StatefulWidget {
  static String id = "chat_bot";
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  bool topicChoose = true;

  bool chooseQuestion = false;
  bool newAns = false; // repeat widget
  bool finish = false;
  Color borderColor = Colors.black26;
  Color buttonColor = Colors.white;
  String topic;
  String question;
  String ans;
  Stream<QuerySnapshot> chatsBot;
  List<String> arrayOfQuestion;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loggedInUser = getCurrentUser();
    getChatBotMessages(loggedInUser).then((val) {
      setState(() {
        chatsBot = val;
      });
    });
    // print(chatsBot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: appBarStyleColor,
        title: Text(
          "Chatbot",
          style: appBarStyleText,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            "Are you sure you want to Delete previous chats"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              
                              Navigator.of(context).pop();
                              removeBotMessages(loggedInUser);
                              setState(() {
                                topicChoose = true;
                                chooseQuestion = false;
                                newAns = false;
                               
                              });
                              
                              // Navigator.of(context).pop();
                              
                            },
                            child: Text("Yes"),
                          )
                        ],
                      );
                    });
              })
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: backImage,
          child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                reverse: true,
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
          messageStream(),
          Container(
              child: topicChoose ? getBotMessage() : Container()),
          if (arrayOfQuestion != null)
            Container(
              child: chooseQuestion ? getQuestion() : Container(),
            ),
          Container(child: newAns ? repeat() : Container()),
          Container(child: finish ? fin() : Container()),
                    ],
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  // To DO: Retrieve Messages, use stream builder
  Widget messageStream() {
    return StreamBuilder(
      stream: chatsBot,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    sender: "",
                    text: snapshot.data.documents[index].get("message"),
                    isme: loggedInUserName ==
                        snapshot.data.documents[index].get("sender"),
                  );
                })
            : Container();
      },
    );
  }

  // First Response asking to choose topic
  Widget getBotMessage() {
    bool clickable = true;
    return Stack(
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BotMessagePadding(
                text: "Select an category you need help with",
              ),
              for (var t in topics)
                FlatButton(
        color: buttonColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          t,
        ),
        onPressed: () {
          if (clickable == true) {
            setState(() {
              topicChoose = false;
              clickable = false;
            });
            updateQuestionList(t);
            addMessageBot("Select an category you need help with", t);
            // Future added since update question was taking time
            Future.delayed(Duration(seconds: 1), () {
              setState(() {
                // topicChoose = false;
                // clickable = false;
                chooseQuestion = true;
                topic = t;
                // arrayOfQuestion =  await addQuestion(topic);

                // addMessageBot(
                //     "Select an category you need help with", topic);
              });
            });
          }
        },
                )
            ],
          ),
      ],
    );
  } // End Of Widget 1

  Widget getQuestion() {
    bool clickable = true;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BotMessagePadding(
              text: "Select a question that best describes your condition",
            ),
            SizedBox(
              height: 5,
            ),
            for (var q in arrayOfQuestion)
              FlatButton(
                color: buttonColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  q,
                ),
                onPressed: () {
                  if (clickable == true) {
                    setState(() {
                      clickable = false;
                      question = q;
                      chooseQuestion = false;

                      addMessageBot(
                          "Select a question that best describes your condition",
                          q);
                      // newAns = true;
                    });
                    getAnswer(question);
                  }
                },
              ),
          ],
        )
      ],
    );
  }

  Widget repeat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BotMessagePadding(
          text:
              "Do you want to select a different question in same category or sleect a new category",
        ),
        FlatButton(
          color: buttonColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            addMessageBot(
                "Do you want to select a different question in same category or sleect a new category",
                "Different Question in same category");
            setState(() {
              newAns = false;
              chooseQuestion = true;
            });
          },
          child: Text("Different Question in same category"),
        ),
        FlatButton(
          color: buttonColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            addMessageBot(
                "Do you want to select a different question in same category or sleect a new category",
                "New Category");
            setState(() {
              newAns = false;
              topicChoose = true;
            });
          },
          child: Text("New Category"),
        ),
      ],
    );
  }

  Widget fin() {
    bool clickable = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BotMessagePadding(
          text: "Do you want to start the process again?",
        ),
        FlatButton(
          color: buttonColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(10)),
          child: Text("Yes"),
          onPressed: () {
            if (clickable) {
              addMessageBot("Do you want to start the process again?", "Yes");
              setState(() {
                newAns = true;
                finish = false;
                clickable = false;
              });
            }
          },
        ),
        FlatButton(
          color: buttonColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(10)),
          child: Text("No"),
          onPressed: () {
            if (clickable) {
              addMessageBot("Do you want to start the process again?", "No");
              Map<String, dynamic> botAnsMap = {
                "sender": "bot",
                "message": "Please come back again if you need any help",
                "time": DateTime.now().millisecondsSinceEpoch + 2
              };
              addChatbotMessagetoFirestore(loggedInUser, botAnsMap);
              setState(() {
                finish = false;
                clickable = false;
              });
            }
          },
        )
      ],
    );
  }

  updateQuestionList(String topic) async {
    arrayOfQuestion = await addQuestion(topic);
    // print(arrayOfQuestion);
  }

  getAnswer(String question) async {
    ans = await getAns(question, topic);
    if (ans != null) {
      Map<String, dynamic> botAnsMap = {
        "sender": "bot",
        "message": ans,
        "time": DateTime.now().millisecondsSinceEpoch + 2
      };
      // print(ans);
      addChatbotMessagetoFirestore(loggedInUser, botAnsMap);
      print(newAns);
      setState(() {
        // newAns = true;
        finish = true;
      });
    }
  }
}

getChatBotMessages(User user) async {
  return firestore
      .collection("users")
      .doc(user.uid)
      .collection("bot_chat")
      .orderBy('time')
      .snapshots();
}

removeBotMessages(User user) {
  firestore
      .collection("users")
      .doc(user.uid)
      .collection("bot_chat")
      .get()
      .then((value) {
    for (var ds in value.docs) {
      ds.reference.delete();
    }
  });
}

// Combination of bot and user message
addMessageBot(String botMessage, String userMessage) {
  Map<String, dynamic> messageMapBot = {
    "sender": "bot",
    "message": botMessage,
    "time": DateTime.now().millisecondsSinceEpoch
  };

  Map<String, dynamic> messageMapUser = {
    "sender": loggedInUserName,
    "message": userMessage,
    "time": DateTime.now().millisecondsSinceEpoch + 1
    // +1 for mainting
  };

  addChatbotMessagetoFirestore(loggedInUser, messageMapBot);
  addChatbotMessagetoFirestore(loggedInUser, messageMapUser);

  // Delay added so that bot message is added first in f
  // Future.delayed(const Duration(seconds: 5), () {
  //   addChatbotMessagetoFirestore(loggedInUser, messageMapUser);
  // });
}

class BotMessagePadding extends StatelessWidget {
  final String text;
  BotMessagePadding({this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
      ),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      elevation: 0,
    );
  }
}
