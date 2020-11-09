import 'package:flutter/material.dart';
import 'package:m_app/constants.dart';
import 'package:m_app/Firebase/autth_methods.dart';
import "package:m_app/components/rounded_button.dart";

class ForgotPass extends StatefulWidget {
  static String id = "forgot_pass";
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController emailEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backImage,
        child: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  SizedBox(
                    height: 24.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 44.0),
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: Colors.green,
                        child: Text(
                          'Send Password Reset Email',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            sendPasswordResetEmail(emailEditingController.text);
                            showAlert(context);
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                "Password Reset Email will be sent to the registered email address",
                style: TextStyle(backgroundColor: Colors.white),
              ),
              // actions: [
              //   new FlatButton(
              //       onPressed: () => Navigator.pop(context),
              //       child: Text("Click Here to Retry"))
              // ],
            ));
  }
}
