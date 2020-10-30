import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_app/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:m_app/screens/forgot_pass.dart';
import 'package:m_app/screens/menu_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:m_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final _firestore = FirebaseFirestore.instance;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  bool showSpinner = false;
  final formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/c2s.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  controller: emailEditingController,
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)
                        ? null
                        : "Enter correct email";
                  },
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Enter email'),
                ),
                // SizedBox(
                //   height: 8.0,
                // ),
                TextFormField(
                  controller: passwordEditingController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  validator: (val) {
                    return val.length < 6
                        ? "Enter Password 6+ characters"
                        : null;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Enter password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: "Login",
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      // singIn();\
                      singIn();
                    }
                  },
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                      color: Colors.transparent,
                      child: Text(
                        'Forgot Password?',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, ForgotPass.id);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  singIn() async {
    setState(() {
      showSpinner = true;
    });
    // try {
    final user = await _auth
        .signInWithEmailAndPassword(
            email: emailEditingController.text,
            password: passwordEditingController.text)
        .catchError((error) {
      print(error.code);
      showAlert(context, error.message);
    });
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email", emailEditingController.text);
      Navigator.pushNamed(context, MenuScreen.id);
    }
    setState(() {
      showSpinner = false;
    });
    // } on PlatformException catch (e) {
    //   showAlert(context, e.message);
    // } on FirebaseAuthException catch (e) {
    //   print(e.code);
    //   showAlert(context, e.message);
    // }
  }

  void showAlert(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                error,
                style: TextStyle(backgroundColor: Colors.white),
              ),
              actions: [
                new FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Click Here to Retry"))
              ],
            ));
  }
}
