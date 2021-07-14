import 'package:growbymargin_webadmin/Screens/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Home/home.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        home: Login(),
        initialRoute: '/',
        routes: {
          "/": (context) => Login(),
          "/home": (context) => Home(),
         
        },
      );
    });
  }
}
