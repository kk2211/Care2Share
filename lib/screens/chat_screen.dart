import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:m_app/Firebase/firestore.dart";
import 'package:m_app/constants.dart';
import 'package:m_app/components/messageBubble.dart';
import "package:profanity_filter/profanity_filter.dart";
import "package:m_app/constants.dart";

class ChatScreen extends StatefulWidget {
  
  // static String id = "chat_screen";
  final String chatRoomId;
  final String userName;
  ChatScreen({this.chatRoomId, this.userName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = new ScrollController();
 
  Stream<QuerySnapshot> chats;
  TextEditingController messageTextController = new TextEditingController();
  String messageText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getChatMessages(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    print(chats);
  }

  @override
  Widget build(BuildContext context) {
     if(_scrollController.hasClients){
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
        }
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
          backgroundColor: appBarStyleColor,
          title: Text(
            widget.userName,
            style: appBarStyleText,
          )),
      body: SafeArea(
          child: Container(
        decoration: backImage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: messageStream()),
            Container(
              
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    
                    child: TextField(
                      
                      controller: messageTextController,
                      decoration: kMessageTextFieldDecoration,
                      onChanged: (value) {
                        messageText = value;
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "send",
                      style: kSendButtonTextStyle,
                    ),
                    onPressed: () {
                      final filter = ProfanityFilter();
                      if (filter.hasProfanity(messageText)) {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    Text("Please don't use improper language"),
                              );
                            });
                      } else {
                        messageTextController.clear();
                        addMessage();
                        FocusManager.instance.primaryFocus.unfocus(); // close keyboard
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  addMessage() {
    if (messageText != null) {
      Map<String, dynamic> messageMap = {
        "sender": widget.userName,
        "message": messageText,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      addMessagetoFirestore(widget.chatRoomId, messageMap);
    }
  }

  Widget messageStream() {
    

    return StreamBuilder(
      
      stream: chats,
      builder: (context, snapshot) {
        
        // if (!snapshot.hasData) {
        //   return Center(child: Text("Not able to reach frebase"));
        // }
        return snapshot.hasData
            ? 
            ListView.builder(
                controller: _scrollController,
                reverse: true,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    sender: widget.userName,
                    text: snapshot.data.documents[index].get("message"),
                    isme: widget.userName ==
                        snapshot.data.documents[index].get("sender"),
                  );
                }
                )
                
            : Container();
            
      },
    );
    
  }
  
}
