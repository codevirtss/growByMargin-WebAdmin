import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MainTainancePage extends StatefulWidget {
  const MainTainancePage({Key? key}) : super(key: key);

  @override
  _MainTainancePageState createState() => _MainTainancePageState();
}

class _MainTainancePageState extends State<MainTainancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 50.h,
          width: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Images/maintaince.gif",
                  
                  ),
                  fit: BoxFit.cover
                  )),
        ),
      ),
    );
  }
}
