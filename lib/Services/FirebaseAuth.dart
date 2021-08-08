import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Auth/LoginScreen.dart';
import 'package:growbymargin_webadmin/Screens/Home/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vrouter/vrouter.dart';

class FirebaseAuthOperations {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get uID {
    try {
      final uid = (FirebaseAuth.instance.currentUser)!.uid;
      return uid;
    } catch (e) {
      return "null";
    }
  }

  Future loginasAdmin(
      BuildContext context, String email, String password) async {
    await auth
        .signInWithEmailAndPassword(
            email: "$email@remedieslifetime.com", password: password)
        .then((value) async {
      context.vRouter.to("/home");
    });
  }

  Future logOutasAdmin(context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(context,
          PageTransition(child: Login(), type: PageTransitionType.rightToLeft));
    });
  }
}
