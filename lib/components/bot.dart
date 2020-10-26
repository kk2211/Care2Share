import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import "dart:convert";

String topic;
// function that returns the bot message
List<String> topics = [
  "depression",
  "anxiety",
  "self-esteem",
  "trauma",
  "anger-management",
  "stress",
  "relationships",
  "addiction"
];

Future<List> addQuestion(String topic) async {
  List<String> ques = [];
  String cont = await rootBundle.loadString("assets/data1.json");
  Map<String, dynamic> qs = jsonDecode(cont);
  var t = qs[topic];

  t.keys.forEach((k) {
    ques.add(k);
  });

  return (ques);
}

Future<String> getAns(String ques, String topic) async {
  String cont = await rootBundle.loadString("assets/data1.json");
  Map<String, dynamic> qs = jsonDecode(cont);
  var t = qs[topic];

  int ran = Random().nextInt(t[ques].length);
  // print("check ans");
 
  return t[ques][ran];
}

