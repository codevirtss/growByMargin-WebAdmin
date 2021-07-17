import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TabletView extends StatefulWidget {
  const TabletView({Key? key}) : super(key: key);

  @override
  _TabletViewState createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
        child: FittedBox(
          child: Text("Tablet"),
        ),
      ),
    );
  }
}
