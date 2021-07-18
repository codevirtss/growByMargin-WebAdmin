import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/desktop_view.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/mobile_view.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/tablet_view.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= 640) {
        return MobileView();
      } else if (constraints.maxWidth < 1007 && constraints.maxWidth > 640) {
        return TabletView();
      } else {
        return DesktopView();
      }
    });
  }
}
