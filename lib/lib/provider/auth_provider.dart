import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAuthProvider extends ChangeNotifier {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  bool islogin = true;
  String enteredEmail = '';
  String enteredPassword = '';

  Future<void> submit(
      GlobalKey<FormState> formKey, BuildContext context) async {
    final _isValid = formKey.currentState!.validate();

    if (!_isValid) {
      return;
    }

    formKey.currentState!.save();

    try {
      if (islogin) {
        await _fireAuth.signInWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
      } else {
        await _fireAuth.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
      }

      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      String errorMessage = "Incorrect email or password";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
          case 'wrong-password':
            errorMessage = "Incorrect email or password";
            break;
          case 'email-already-in-use':
            errorMessage = "Email already in use";
            break;
          default:
            errorMessage = errorMessage;
        }
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    notifyListeners();
  }

  void toggleLogin() {
    islogin = !islogin;
    notifyListeners();
  }
}
