import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final now = DateTime.now();

Future<String> getQuote() async {
  String quote =
      "Mental health…is not a destination, but a process. It’s about how you drive, not where you’re going";
  var response = await http.get('https://api.quotable.io/random');
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    quote = (jsonResponse["content"]);
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("quote", quote);
  prefs.setInt("call_time", DateTime.now().millisecondsSinceEpoch);
  return quote;
}

// addTime() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setInt("call_time", DateTime.now().millisecondsSinceEpoch);
// }

// getTime() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   int call_time = prefs.getInt("call_time");
//   return call_time
// }

Future<String> displayQuote(time) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int timestamp =
      prefs.getInt("call_time") ?? DateTime(now.day - 1).millisecondsSinceEpoch;
  DateTime callTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  if (time.difference(callTime).inDays != 0) {
    getQuote();
  }

  // print(callTime.difference(time).inDays);

  return prefs.getString("quote") ??
      "Mental health…is not a destination, but a process. It’s about how you drive, not where you’re going";
}
