import 'package:firebase_auth/firebase_auth.dart';

var auth = FirebaseAuth.instance;
User getCurrentUser() {
  User loggedInUser;
  try {
    final user = auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  } catch (e) {
    print(e);
  }
  return loggedInUser;
}
