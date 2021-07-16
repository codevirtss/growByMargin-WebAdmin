import 'package:firebase_core/firebase_core.dart';
import 'package:growbymargin_webadmin/Screens/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Auth/Navigation.dart';
import 'package:growbymargin_webadmin/Screens/Home/home.dart';
import 'package:growbymargin_webadmin/Screens/Product/ManageProduct/manageProduct.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/uploadProductScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:vrouter/vrouter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return VRouter(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        initialUrl: "/",
        routes: [
          VWidget(path: "/", widget: Navigation()),
          VWidget(path: "/home", widget: Home()),
          VWidget(path: "/uploadProducts", widget: UploadProduct()),
          // VWidget(path: "/manageProduct", widget: ManageProduct()),
          VRouteRedirector(path: ':_(.+)', redirectTo: "/home")
        ],
      );
    });
  }
}
