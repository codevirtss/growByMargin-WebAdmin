import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Auth/Navigation.dart';
import 'package:growbymargin_webadmin/Screens/Home/home.dart';
import 'package:growbymargin_webadmin/Screens/Offers/offerUpload.dart';
import 'package:growbymargin_webadmin/Screens/Offers/offers.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/desktop_view.dart';
import 'package:growbymargin_webadmin/Screens/ViewUsers/viewUser.dart';
import 'package:sizer/sizer.dart';
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
          VWidget(path: "/offers", widget: Offers()),
          VWidget(path: "/offerUpload", widget: OfferUpload()),
          VWidget(path: "/upload", widget: DesktopView()),
          VWidget(path: "/allUsers", widget: ViewUser()),
          VRouteRedirector(path: ':_(.+)', redirectTo: "/home")
        ],
      );
    });
  }
}
