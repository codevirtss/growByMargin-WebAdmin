import 'package:firebase_core/firebase_core.dart';
import 'package:growbymargin_webadmin/Screens/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Auth/Navigation.dart';
import 'package:growbymargin_webadmin/Screens/Home/home.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/uploadProductScreen.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        initialRoute: '/uploadProdcuts',
        routes: {
          "/": (context) => Navigation(),
          "/home": (context) => Home(),
          "/uploadProdcuts": (context) => UploadProduct(
                key: key,
              ),
        },
      );
    });
  }
}
