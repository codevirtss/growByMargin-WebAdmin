import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:growbymargin_webadmin/Utils/colors.dart';

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
                return Container(
                  child: offerData.length != 0
                      ? GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: offerData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Container(
                                height: 50.w,
                                width: 30.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                            color: constantColors.greyColor,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    offerData[index]
                                                        ["imageUrl"]),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(2.sp)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        offerData[index]["type"] == "UrlOffer"
                                            ? offerData[index]["destinationUrl"]
                                            : "",
                                        style: GoogleFonts.nunito(
                                            color: constantColors.blackColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: TextButton(
                                              onPressed: () async {
                                                print(offerData[index]
                                                    ["OfferId"]);

                                                return showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Aler'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(
                                                                'Do ypu want to delete this offer!'),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('ok'),
                                                          onPressed: () async {
                                                            Reference
                                                                reference =
                                                                FirebaseStorage
                                                                    .instance
                                                                    .refFromURL(
                                                                        offerData[index]
                                                                            [
                                                                            "imageUrl"]);
                                                            print(reference);
                                                            await reference
                                                                .delete();
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Offers")
                                                                .doc(offerData[
                                                                        index]
                                                                    ["OfferId"])
                                                                .delete()
                                                                .then((value) {
                                                              return showDialog<
                                                                  void>(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false, // user must tap button!
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Success'),
                                                                    content:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          ListBody(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              'This to inform you offer has been deleted!'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        child: Text(
                                                                            'ok'),
                                                                        onPressed:
                                                                            () async {
                                                                          context
                                                                              .vRouter
                                                                              .to("/home");
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }).catchError((e) {
                                                              return showDialog<
                                                                  void>(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false, // user must tap button!
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Error'),
                                                                    content:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          ListBody(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              '${e.toString()}'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        child: Text(
                                                                            'ok'),
                                                                        onPressed:
                                                                            () async {
                                                                          context
                                                                              .vRouter
                                                                              .to("/home");
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text("Delet Offer")),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: constantColors.greyColor)
                                    // borderRadius: BorderRadius.circular(10.sp)
                                    ),
                              ),
                            );
                          },
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                        )
                      : Container(
                          child: Center(
                            child: Image.asset("assets/Images/offer.gif"),
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
