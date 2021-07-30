import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Utils/Dimensions.dart';
import 'package:growbymargin_webadmin/Utils/Responsive.dart';
import 'package:growbymargin_webadmin/Utils/Strigns.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:vrouter/vrouter.dart';

class OfferUpload extends StatefulWidget {
  const OfferUpload({Key? key}) : super(key: key);

  @override
  _OfferUploadState createState() => _OfferUploadState();
}

class _OfferUploadState extends State<OfferUpload> {
  ConstantColors constantColors = ConstantColors();
  TextEditingController destination = TextEditingController();
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
          .child(Offers_Collec)
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
              'Create Offer',
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
                  onPressed: () async {
                    if (destination.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection(Offers_Collec)
                          .doc(offerId!)
                          .set({
                        "destinationUrl": destination.text,
                        "imageUrl": imageUrl,
                        "OfferId": offerId!,
                        "type": "UrlOffer"
                      }).whenComplete(() {
                          return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                  'Your Add has been Created'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('ok'),
                            onPressed: () {
                        context.vRouter.to("/offer");
                            },
                          ),
                        ],
                      );
                    },
                  );
                      });
                    }else{
                       return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Alert'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              
                              Text(
                                  'This is to inform you that the fields are empty'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                    }
                  },
                  icon: Icon(EvaIcons.upload))
            ]),
        body: Responsive(
          desktop: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 20.h,
                          width: 30.h,
                          child: Center(
                              child: imageUrl == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            pickCoverImage();
                                          },
                                          icon: Icon(
                                            EvaIcons.imageOutline,
                                            size: 20.sp,
                                            color: constantColors.mainColor,
                                          ),
                                        ),
                                        vSizedBox2,
                                        Text(
                                          "Add cover Image",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  : Image.network(imageUrl!)),
                          decoration: BoxDecoration(
                              color: constantColors.greyColor,
                              borderRadius: BorderRadius.circular(10.sp)),
                        )),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: hBox2, top: vBox2),
                      child: Text(
                        "Enter your Destination Url",
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 10.0.h,
                      width: 50.0.h,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: destination,
                        decoration: InputDecoration(
                            labelText: "Destination Url",
                            labelStyle: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.normal),
                            hintText: "https://bytespaces.studio/",
                            hintStyle: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          mobile: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 20.h,
                          width: 30.h,
                          child: Center(
                              child: imageUrl == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            pickCoverImage();
                                          },
                                          icon: Icon(
                                            EvaIcons.imageOutline,
                                            size: 20.sp,
                                            color: constantColors.mainColor,
                                          ),
                                        ),
                                        vSizedBox2,
                                        Text(
                                          "Add cover Image",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  : Image.network(imageUrl!)),
                          decoration: BoxDecoration(
                              color: constantColors.greyColor,
                              borderRadius: BorderRadius.circular(10.sp)),
                        )),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: hBox2, top: vBox2),
                      child: Text(
                        "Enter your Destination Url",
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 10.0.h,
                      width: 50.0.h,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: destination,
                        decoration: InputDecoration(
                            labelText: "Destination Url",
                            labelStyle: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.normal),
                            hintText: "https://bytespaces.studio/",
                            hintStyle: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          tablet: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 20.h,
                          width: 20.h,
                          child: Center(
                              child: imageUrl == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            pickCoverImage();
                                          },
                                          icon: Icon(
                                            EvaIcons.imageOutline,
                                            size: 20.sp,
                                            color: constantColors.mainColor,
                                          ),
                                        ),
                                        vSizedBox2,
                                        Text(
                                          "Add cover Image",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  : Image.network(imageUrl!)),
                          decoration: BoxDecoration(
                              color: constantColors.greyColor,
                              borderRadius: BorderRadius.circular(10.sp)),
                        )),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: hBox2, top: vBox2),
                      child: Text(
                        "Enter your Destination Url",
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 10.0.h,
                      width: 50.0.h,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: destination,
                        decoration: InputDecoration(
                            labelText: "Destination Url",
                            labelStyle: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.normal),
                            hintText: "https://bytespaces.studio/",
                            hintStyle: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
