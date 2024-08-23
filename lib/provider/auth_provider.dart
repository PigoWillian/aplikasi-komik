import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAuthProvider extends ChangeNotifier {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;

  var islogin = true;
  var enteredEmail = '';
  var enteredPassword = '';

  void submit(GlobalKey<FormState> formKey, BuildContext context) async {
    final _isvalid = formKey.currentState!.validate();

    if (!_isvalid) {
      return;
    }

    formKey.currentState!.save();

    try {
      if (islogin) {
        // ignore: unused_local_variable
        final UserCredential = await _fireAuth.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
      } else {
        // ignore: unused_local_variable
        final UserCredential = await _fireAuth.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
      }

      // Navigasi ke halaman home setelah login berhasil
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          print("Email already in use");
        } else {
          print(e.message);
        }
      } else {
        print(e);
      }
    }

    notifyListeners();
  }
}
