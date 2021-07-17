import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Utils/Dimensions.dart';
import 'package:growbymargin_webadmin/Utils/Responsive.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  ConstantColors constantColors = ConstantColors();
  String? offerId = Uuid().v4();
  String? imageUrl;
  void pickCoverImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      Uint8List? uploadFile = result.files.single.bytes;

      String? filename = result.files.single.name;

      Reference reference = FirebaseStorage.instance
          .ref()
          .child("Offers")
          .child(offerId!)
          .child('CoverImages');

      final UploadTask uploadTask = reference.putData(uploadFile!);
      uploadTask.whenComplete(() async {
        String coverImage = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = coverImage;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      appBar: AppBar(
          title: Text(
            'Offers',
            style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: constantColors.whiteColor,
          iconTheme: IconThemeData(color: constantColors.blackColor),
          actions: <Widget>[
            IconButton(
              icon: Icon(EvaIcons.upload),
              onPressed: () {},
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20.h,
                  width: 30.h,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              EvaIcons.image,
                              size: 20.sp,
                              color: constantColors.mainColor,
                            ))
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      color: constantColors.greyColor),
                ),
                hSizedBox1,
                Container(
                  height: 20.h,
                  width: 30.h,
                    child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              EvaIcons.image,
                              size: 20.sp,
                              color: constantColors.mainColor,
                            ))
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      color: constantColors.greyColor),
                )
              ],
            ),
            vSizedBox1,
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20.h,
                  width: 30.h,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              EvaIcons.image,
                              size: 20.sp,
                              color: constantColors.mainColor,
                            ))
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      color: constantColors.greyColor),
                ),
                hSizedBox1,
                Container(
                  height: 20.h,
                  width: 30.h,
                    child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              EvaIcons.image,
                              size: 20.sp,
                              color: constantColors.mainColor,
                            ))
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      color: constantColors.greyColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
