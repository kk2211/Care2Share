import 'package:flutter/material.dart';
import 'package:m_app/MoodDiary/helpers/db_helper.dart';
import 'package:m_app/MoodDiary/helpers/mooddata.dart';
import 'package:m_app/MoodDiary/models/moodcard.dart';
import 'package:m_app/MoodDiary/screens/chart.dart';
import 'package:m_app/MoodDiary/widgets/mooddaycard.dart';
import 'package:m_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  static String id = "mood_homepage";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    loader = Provider.of<MoodCard>(context, listen: true).isloading;
    return loader
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
          backgroundColor: Colors.lightBlue[50],
            appBar: AppBar(
              title: Text('Your Moods',style: appBarStyleText,),
              backgroundColor: appBarStyleColor,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.show_chart,color: Colors.white,),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(MoodChart.id))
              ],
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: backImage,
              child: FutureBuilder<List>(
                future: DBHelper.getData('user_moods'),
                initialData: List(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int position) {
                            var imagestring = snapshot.data[position]['actimage'];
                            List<String> img = imagestring.split('_');
                            List<String> name =
                                snapshot.data[position]['actname'].split("_");
                            Provider.of<MoodCard>(context, listen: false)
                                .actiname
                                .addAll(name);
                            Provider.of<MoodCard>(context, listen: false)
                                .data
                                .add(MoodData(
                                    snapshot.data[position]['mood'] == 'Angry'
                                        ? 1
                                        : snapshot.data[position]['mood'] ==
                                                'Happy'
                                            ? 2
                                            : snapshot.data[position]['mood'] ==
                                                    'Sad'
                                                ? 3
                                                : snapshot.data[position]['mood'] ==
                                                        'Surprised'
                                                    ? 4
                                                    : snapshot.data[position]
                                                                ['mood'] ==
                                                            'Loving'
                                                        ? 5
                                                        : snapshot.data[position]
                                                                    ['mood'] ==
                                                                'Scared'
                                                            ? 6
                                                            : 7,
                                    snapshot.data[position]['date'],
                                    snapshot.data[position]['mood'] == 'Angry'
                                        ? charts.ColorUtil.fromDartColor(
                                            Colors.red)
                                        : snapshot.data[position]['mood'] ==
                                                'Happy'
                                            ? charts.ColorUtil.fromDartColor(
                                                Colors.blue)
                                            : snapshot.data[position]['mood'] ==
                                                    'Sad'
                                                ? charts.ColorUtil.fromDartColor(
                                                    Colors.green)
                                                : snapshot.data[position]['mood'] ==
                                                        'Surprised'
                                                    ? charts.ColorUtil.fromDartColor(Colors.pink)
                                                    : snapshot.data[position]['mood'] == 'Loving'
                                                        ? charts.ColorUtil.fromDartColor(Colors.purple)
                                                        : snapshot.data[position]['mood'] == 'Scared'
                                                            ? charts.ColorUtil.fromDartColor(Colors.black)
                                                            : charts.ColorUtil.fromDartColor(Colors.white)));

                            return MoodDay(
                                snapshot.data[position]['image'],
                                snapshot.data[position]['datetime'],
                                snapshot.data[position]['mood'],
                                img,
                                name);
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          );
  }
}
