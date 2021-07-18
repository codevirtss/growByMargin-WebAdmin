import 'package:firebase_core/firebase_core.dart';
import 'package:growbymargin_webadmin/Screens/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Auth/Navigation.dart';
import 'package:growbymargin_webadmin/Screens/Home/home.dart';
import 'package:growbymargin_webadmin/Screens/Offers/offers.dart';
import 'package:growbymargin_webadmin/Screens/Product/ManageProduct/manageProduct.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/desktop_view.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/uploadProductScreen.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/upload_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterSizer(builder: (context, orientation, deviceType) {
      return VRouter(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        initialUrl: "/upload",
        routes: [
          VWidget(path: "/", widget: Navigation()),
          VWidget(path: "/home", widget: Home()),
          VWidget(path: "/upload", widget: Upload()),
          VWidget(path: "/uploadProducts", widget: UploadProduct()),
          VWidget(path: "/offers", widget: Offers()),
          VWidget(path: "/upload", widget: DesktopView()),
          VRouteRedirector(path: ':_(.+)', redirectTo: "/home")
        ],
      );
    });
  }
}
