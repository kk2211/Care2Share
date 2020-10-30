import 'package:flutter/material.dart';
import 'package:m_app/MoodDiary/screens/chart.dart';
import 'package:m_app/MoodDiary/screens/homepage.dart';
import 'package:m_app/screens/chat_menu.dart';
import 'package:m_app/screens/chatbot.dart';
import 'package:m_app/screens/forgot_pass.dart';
import 'package:m_app/screens/menu_screen.dart';
import 'package:m_app/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'MoodDiary/screens/start.dart';
import 'package:provider/provider.dart';
import 'MoodDiary/models/moodcard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MChat(route: email == null ? WelcomeScreen.id : MenuScreen.id));
  });
  // runApp(MChat(route: email == null ? WelcomeScreen.id : MenuScreen.id));
}

class MChat extends StatelessWidget {
  MChat({this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: MoodCard(),
        child: MaterialApp(
          initialRoute: route,
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            MenuScreen.id: (context) => MenuScreen(),
            ForgotPass.id: (context) => ForgotPass(),
            ChatBot.id: (context) => ChatBot(),
            ChatMenu.id: (context) => ChatMenu(),
            StartPage.id: (context) => StartPage(),
            HomeScreen.id: (context) => HomeScreen(),
            MoodChart.id: (context) => MoodChart()
          },
        ));
  }
}
