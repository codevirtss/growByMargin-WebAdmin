import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:sizer/sizer.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({Key? key}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
          backgroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0.w))),
          child: Container(
              height: 80.0.w,
              width: 40.0.h,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.0.w,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0.w, horizontal: 3.0.h),
                        child: Text(
                          "Upload a Book",
                          style: GoogleFonts.montserrat(
                              color: Color(0xff394C73),
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2.0.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
                        child: Text(
                          "Preview Book",
                          style: GoogleFonts.montserrat(
                              color: Colors.blueGrey,
                              fontSize: 6.0.sp,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0.w, horizontal: 3.0.h),
                        child: Container(
                          height: 7.0.w,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 9,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.0.h),
                                      child: Text("bhukss/hshsbkoisk.jpg",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.grey,
                                              fontSize: 8.0.sp,
                                              fontWeight: FontWeight.w500)))),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Icon(
                                      FontAwesomeIcons.upload,
                                      color: ConstantColors.greenColor,
                                    ),
                                  ))
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.grey[350]!)),
                        ),
                      ),
                      SizedBox(
                        height: 2.0.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h, left: 3.0.w),
                        child: Text(
                          "Full Book",
                          style: GoogleFonts.montserrat(
                              color: Colors.blueGrey,
                              fontSize: 6.0.sp,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0.h, horizontal: 3.0.h),
                        child: Container(
                          height: 7.0.w,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 9,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.0.h),
                                      child: Text("bhukss/hshsbkoisk.jpg",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.grey,
                                              fontSize: 8.0.sp,
                                              fontWeight: FontWeight.w500)))),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Icon(
                                      FontAwesomeIcons.upload,
                                      color: ConstantColors.greenColor,
                                    ),
                                  ))
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.grey[350]!)),
                        ),
                      ),
                      SizedBox(
                        height: 2.0.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
                        child: Text(
                          "Cover Image",
                          style: GoogleFonts.montserrat(
                              color: Colors.blueGrey,
                              fontSize: 6.0.sp,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0.w, horizontal: 3.0.h),
                        child: Container(
                          height: 20.0.w,
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.solidFolderOpen,
                              size: 25.0.sp,
                              color: ConstantColors.greenColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.grey[350]!)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 3.0.h, top: 2.0.w),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(10),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(2.0.h)),
                                    backgroundColor: MaterialStateProperty.all(
                                        ConstantColors.blueColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1.0.h))))),
                                onPressed: () {},
                                child: Text(
                                  "Upload",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.w300),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.0.w,
                      )
                    ]),
              ))),
    );
  }
}
