import 'package:flutter/material.dart';
import 'package:m_app/components/rounded_button.dart';
import 'package:m_app/constants.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
        body: Container(
          decoration: backImage,
          child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
                        child: Container(
                child: Image.asset('images/c2s.png',width: 200),
                height: 200,
                width: 200,
              ),
            ),
            
            Center(
              child: Text(
                "Care2Share",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundedButton(
              title: 'Login',
              // color: Colors.lightBlueAccent,
              color: Colors.green,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              // color: Colors.lightBlueAccent,
              color: Colors.green,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
      ),
    ),
        ));
  }
}
