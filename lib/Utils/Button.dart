import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:sizer/sizer.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final onpress;

  const ButtonWidget(
      {Key? key,
      required this.constantColors,
      required this.onpress,
      required this.title})
      : super(key: key);

  final ConstantColors constantColors;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpress,
      child: Text(
        "$title",
      ),
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          primary: constantColors.blackColor,
          minimumSize: Size(100, 50),
          // padding:
          //     EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
          backgroundColor: constantColors.mainColor,
          side: BorderSide(
              color: constantColors.blackColor,
              width: 2,
              style: BorderStyle.solid)),
    );
  }
}
