import 'package:flutter/cupertino.dart';
// import 'package:moodairy/helpers/db_helper.dart';
// import 'package:moodairy/helpers/mooddata.dart';
// import 'package:moodairy/models/activity.dart';
import "package:m_app/MoodDiary/helpers/db_helper.dart";
import "package:m_app/MoodDiary/helpers/mooddata.dart";
import "package:m_app/MoodDiary/models/activity.dart";

class MoodCard extends ChangeNotifier {
  String datetime;
  String mood;
  List<String> activityname = [];
  List<String> activityimage = [];
  String image;
  String actimage;
  String actname;
  MoodCard({this.actimage, this.actname, this.datetime, this.image, this.mood});
  List items;
  List<MoodData> data=[];
  String date;
  bool isloading=false;
  List<String> actiname=[];


  void add(Activity act) {
    activityimage.add(act.image);
    activityname.add(act.name);
    notifyListeners();
  }


  Future<void> addPlace(
    String datetime,
    String mood,
    String image,
    String actimage,
    String actname,
    String date
  ) async {
    DBHelper.insert('user_moods', {
      'datetime': datetime,
      'mood': mood,
      'image': image,
      'actimage': actimage,
      'actname': actname,
      'date':date
    });
    notifyListeners();
  }

  Future<void> deletePlaces(String datetime) async {
    DBHelper.delete(datetime);
    notifyListeners();
  }
}
