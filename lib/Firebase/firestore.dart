import "package:cloud_firestore/cloud_firestore.dart";
import "dart:math";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

var firestore = FirebaseFirestore.instance;

// Handle all the logic for getting user and updating firestore
Future<String> getRandomUser(User user) async {
  var matchedUserDocid;
  var pairedUsers = new List();
  int flag = 0;

  String userToPair; // value which will be returned
  String currUserName;

  var usersInDb = new Set();

  // Collect all the users in firestore
  await firestore.collection("users").get().then((QuerySnapshot value) {
    value.docs.forEach((element) {
      // print(element.data()['userName']);
      if (element.data()["ready"] == true) {
        usersInDb.add(element.data()['userName']);
      }
    });
  });

  // find  user
  await firestore.collection("users").doc(user.uid).get().then((value) {
    currUserName = value.data()["userName"];
    pairedUsers = (value.data()["paired"]);
    // print(pairedUsers);

    for (var i in usersInDb) {
      if (pairedUsers.contains(i) == false && i != currUserName) {
        userToPair = i;
        pairedUsers.add(i);
        flag = 1;
        break;
      }
    }
  });
  if (flag == 0) {
    print("Not Found");
    return null;
  }

  // adding paired Users list back into the db
  await firestore
      .collection("users")
      .doc(user.uid)
      .update({"paired": pairedUsers});

  // Getting id of the mathced user
  await firestore
      .collection("users")
      .where("userName", isEqualTo: userToPair)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      matchedUserDocid = element.id;
    });
  });
  // print(matchedUserDocid);
  await firestore.collection("users").doc(matchedUserDocid).update({
    "paired": FieldValue.arrayUnion([currUserName])
  });

  setReadytoPairFalse(user.uid);
  setReadytoPairFalse(matchedUserDocid);

  // print(usersInDb);

  return userToPair;
}

Future<String> getCurrUserName(User user) async {
  String currUserName;
  await firestore.collection("users").doc(user.uid).get().then((value) {
    currUserName = value.data()["userName"];
  });
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("username", currUserName);
  // print(prefs.getString("username"));

  // return currUserName;
}

Future<bool> addChatRoom(chatRoom, chatRoomId) {
  firestore
      .collection("chatRoom")
      .doc(chatRoomId)
      .set(chatRoom)
      .catchError((e) {
    print(e);
  });
}

upDateReadytoPair(User user) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // int yesterday = prefs.getInt("yesterday") ?? 0;
  var yesterday;
  firestore.collection("users").doc(user.uid).get().then((value) {
    yesterday = value.data()["dayPair"];
  });

  if (yesterday != DateTime.now().day) {
    firestore
        .collection("users")
        .doc(user.uid)
        .update({"ready": true, "dayPair": DateTime.now().day});
    // prefs.setInt("yesterday", DateTime.now().day);
  }
}

setReadytoPairFalse(String id) {
  firestore.collection("users").doc(id).update({"ready": false});
  print("Inside readyToPair");
}

getUserChats(myName) async {
  return firestore
      .collection("chatRoom")
      .where("users", arrayContains: myName)
      .snapshots();
}

getChatMessages(String chatRoomId) async {
  return firestore
      .collection("chatRoom")
      .doc(chatRoomId)
      .collection("chats")
      .orderBy('time',descending: true)
      
      .snapshots();
}

addMessagetoFirestore(String chatRoomId, messageData) {
  firestore
      .collection("chatRoom")
      .doc(chatRoomId)
      .collection("chats")
      .add(messageData)
      .catchError((e) {});
}

addChatbotMessagetoFirestore(User user, messageData) {
  firestore
      .collection("users")
      .doc(user.uid)
      .collection("bot_chat")
      .add(messageData)
      .catchError((e) {});
}
