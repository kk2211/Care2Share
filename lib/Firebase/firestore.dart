import "package:cloud_firestore/cloud_firestore.dart";
import "dart:math";
import 'package:firebase_auth/firebase_auth.dart';

var firestore = FirebaseFirestore.instance;

// var pairedUsers = new List();
// String userToPair;
// String currUserName;

// Handle all the logic for getting user and updating firestore
Future<String> getRandomUser(User user) async {
  var matchedUserDocid;
  var pairedUsers = new List();
  var matchedUserList = new List();
  String userToPair; // value which will be returned
  String currUserName;

  var usersInDb = new Set();

  // Collect all the users in firestore
  await firestore.collection("users").get().then((QuerySnapshot value) {
    value.docs.forEach((element) {
      // print(element.data()['userName']);
      usersInDb.add(element.data()['userName']);
    });
  });

  // find  user
  await firestore.collection("users").doc(user.uid).get().then((value) {
    currUserName = value.data()["userName"];
    pairedUsers = (value.data()["paired"]);
    print(pairedUsers);
    int flag = 0;
    for (var i in usersInDb) {
      if (pairedUsers.contains(i) == false && i != currUserName) {
        userToPair = i;
        pairedUsers.add(i);
        flag = 1;
        break;
      }
    }
    if (flag == 0) {
      print("Not Found");
    }
  });

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

  // print(usersInDb);
  print(pairedUsers);

  return userToPair;
}
