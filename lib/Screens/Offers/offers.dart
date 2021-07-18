import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Screens/Offers/offerUpload.dart';
import 'package:growbymargin_webadmin/Utils/Responsive.dart';
import 'package:growbymargin_webadmin/Utils/Strigns.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:vrouter/vrouter.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
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

  var offerData;
  Future getAllOffers() async {
    await FirebaseFirestore.instance.collection("Offers").get().then((value) {
      offerData = value.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: constantColors.mainColor,
          onPressed: () {
            context.vRouter.to("/offerUpload");
          },
          child: Icon(Icons.add),
        ),
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
            actions: <Widget>[]),
        body: FutureBuilder(
            future: getAllOffers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Responsive(
                    mobile: Container(
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: offerData.length,
                        itemBuilder: (context, index) {
                          return Card(
                        child: Container(
                          height: 40.h,
                          width: 30.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: constantColors.greyColor,
                                      image: DecorationImage(
                                          image: NetworkImage(offerData[index]
                                              ["imageUrl"]),
                                          fit: BoxFit.cover),
                                      borderRadius:
                                          BorderRadius.circular(2.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  offerData[index]["destinationUrl"],
                                  style: GoogleFonts.nunito(
                                      color: constantColors.blackColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: constantColors.mainColor,
                                      borderRadius:
                                          BorderRadius.circular(2.sp)),
                                  child: Text(
                                    offerData[index]["destinationUrl"],
                                    style: GoogleFonts.nunito(
                                        color: constantColors.blackColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: TextButton(
                                        onPressed: () {
                                          print(
                                              "Book Id :${offerData[index]["OfferId"]}");
                                      
                                        },
                                        child: Text("Edit book")),
                                  )
                                ],
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: constantColors.greyColor)
                              // borderRadius: BorderRadius.circular(10.sp)
                              ),
                        ),
                      );
                        },
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                      ),
                    ),
                    tablet: Container(
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: offerData.length,
                        itemBuilder: (context, index) {
                          return Card(
                        child: Container(
                          height: 40.h,
                          width: 30.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: constantColors.greyColor,
                                      image: DecorationImage(
                                          image: NetworkImage(offerData[index]
                                              ["imageUrl"]),
                                          fit: BoxFit.cover),
                                      borderRadius:
                                          BorderRadius.circular(2.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  offerData[index]["destinationUrl"],
                                  style: GoogleFonts.nunito(
                                      color: constantColors.blackColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: constantColors.mainColor,
                                      borderRadius:
                                          BorderRadius.circular(2.sp)),
                                  child: Text(
                                    offerData[index]["destinationUrl"],
                                    style: GoogleFonts.nunito(
                                        color: constantColors.blackColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: TextButton(
                                        onPressed: () {
                                          print(
                                              "Book Id :${offerData[index]["OfferId"]}");
                                      
                                        },
                                        child: Text("Edit book")),
                                  )
                                ],
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: constantColors.greyColor)
                              // borderRadius: BorderRadius.circular(10.sp)
                              ),
                        ),
                      );
                        },
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                      ),
                    ),
                  
                    desktop: Container(
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: offerData.length,
                        itemBuilder: (context, index) {
                          return Card(
                        child: Container(
                          height: 40.h,
                          width: 30.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: constantColors.greyColor,
                                      image: DecorationImage(
                                          image: NetworkImage(offerData[index]
                                              ["imageUrl"]),
                                          fit: BoxFit.cover),
                                      borderRadius:
                                          BorderRadius.circular(2.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  offerData[index]["destinationUrl"],
                                  style: GoogleFonts.nunito(
                                      color: constantColors.blackColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: constantColors.mainColor,
                                      borderRadius:
                                          BorderRadius.circular(2.sp)),
                                  child: Text(
                                    offerData[index]["destinationUrl"],
                                    style: GoogleFonts.nunito(
                                        color: constantColors.blackColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: TextButton(
                                        onPressed: () {
                                          print(
                                              "Book Id :${offerData[index]["OfferId"]}");
                                      
                                        },
                                        child: Text("Edit book")),
                                  )
                                ],
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: constantColors.greyColor)
                              // borderRadius: BorderRadius.circular(10.sp)
                              ),
                        ),
                      );
                        },
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                      ),
                    ),
                    );
              } else {
                print("Not done");
                return Container(
                  child: Center(
                    child: Image.asset("assets/Images/offer.gif"),
                  ),
                );
              }
            }));
  }
}
