import 'package:flutter/material.dart';
import 'package:m_app/screens/forgot_pass.dart';
import 'package:m_app/screens/menu_screen.dart';
import 'package:m_app/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  runApp(MChat(route: email==null?WelcomeScreen.id:MenuScreen.id));
}

class MChat extends StatelessWidget  {
  MChat({this.route});
 final String route;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      initialRoute: route,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        MenuScreen.id: (context) => MenuScreen(),
        ForgotPass.id: (context) => ForgotPass(),
      },
    );
  }
}
