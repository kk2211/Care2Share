import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:m_app/constants.dart';
import "package:flutter/material.dart";
import 'package:m_app/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  bool showSpinner = false;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: "logo",
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
                  controller: usernameEditingController,
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  validator: (val) {
                    return val.isEmpty || val.length < 3
                        ? "Enter Username 3+ characters"
                        : null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your username'),
                ),
                SizedBox(
                  height: 8,
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
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: passwordEditingController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  validator: (val) {
                    return val.length < 6
                        ? "Enter Password 6+ characters"
                        : null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Register',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      signUp();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signUp() async {
    setState(() {
      showSpinner = true;
    });
    try {
      print("insdide");
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: emailEditingController.text,
          password: passwordEditingController.text);
      if (newUser != null) {
        Map<String,dynamic> userData = {
          "userName": usernameEditingController.text,
          "userEmail": emailEditingController.text,
          "paired": new List()
        };
         _auth.signInWithEmailAndPassword(
            email: emailEditingController.text,
            password: passwordEditingController.text);
        var currUser = _auth.currentUser;
        // Setting docId as userId
        FirebaseFirestore.instance
            .collection("users")
            .doc(currUser.uid)
            .set(userData)
            .catchError((e) {
          print(e.toString());
        });
        // newFirebaseUser.displayName = username;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("email", emailEditingController.text);
        Navigator.pushNamed(context, MenuScreen.id);
      }
      setState(() {
        showSpinner = false;
      });
    } on PlatformException catch (e) {
      showAlert(context, e.message);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showAlert(context, e.message);
    }
  }

  void showAlert(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(error),
            ));
  }
}
