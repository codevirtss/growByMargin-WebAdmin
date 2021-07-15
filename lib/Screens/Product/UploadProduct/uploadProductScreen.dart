import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Screens/Auth/LoginWidget.dart';
import 'package:growbymargin_webadmin/Utils/Dimensions.dart';
import 'package:sizer/sizer.dart';

class UploadProduct extends StatefulWidget {
  const UploadProduct({Key? key}) : super(key: key);

  @override
  _UploadProductState createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  TextEditingController collectionNameController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookDiscrController = TextEditingController();

  String? imageUrl;

  void pickCoverImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.whiteColor,
        appBar: AppBar(
          title: Text(
            'Upload Product',
            style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: constantColors.whiteColor,
          iconTheme: IconThemeData(color: constantColors.blackColor),
          actions: [
            IconButton(
              tooltip: "Upload Your Product To DataBase",
              onPressed: () {
                print("uploading....");
              },
              icon: Icon(EvaIcons.uploadOutline),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 30.h,
                      width: 30.h,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              EvaIcons.imageOutline,
                              size: 20.sp,
                              color: constantColors.mainColor,
                            ),
                          ),
                          Text(
                            "Add cover Image",
                            style: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                      decoration: BoxDecoration(
                          color: constantColors.greyColor,
                          borderRadius: BorderRadius.circular(10.sp)),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        """Upload coverImage fro
your product""",
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: hBox2, top: vBox2),
                child: Text(
                  "Enter your collection name",
                  style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: collectionNameController,
                  decoration: InputDecoration(
                      labelText: "Collection name",
                      labelStyle: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.normal),
                      hintText: "HurbalLife",
                      hintStyle: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.normal)),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: bookNameController,
                  decoration: InputDecoration(
                      labelText: "Book name",
                      labelStyle: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.normal),
                      hintText: "",
                      hintStyle: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.normal)),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: bookDiscrController,
                  maxLines: null,
                  maxLength: null,
                  decoration: InputDecoration(
                      labelText: "About the books",
                      labelStyle: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.normal),
                      hintText: "Add discription about this ebook",
                      hintStyle: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.normal)),
                ),
              ),
            ],
          ),
        ));
  }
}
