import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Screens/Product/ManageProduct/manageProduct.dart';
import 'package:growbymargin_webadmin/Services/FirebaseAuth.dart';
import 'package:growbymargin_webadmin/Utils/Responsive.dart';
import 'package:growbymargin_webadmin/Utils/Strigns.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:growbymargin_webadmin/Utils/custom_dialog2.dart';
import 'package:oktoast/oktoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';
import 'package:vrouter/vrouter.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

FirebaseAuthOperations firebaseAuthOperations = FirebaseAuthOperations();

class _HomeState extends State<Home> {
  ConstantColors constantColors = ConstantColors();

  var bookData;
  String? imageUrl;
  String? offerId = Uuid().v4();
  Future getAllBooks() async {
    await FirebaseFirestore.instance
        .collection(BOOK_COLLECTION)
        .get()
        .then((value) {
      bookData = value.docs;
    });
  }

  void _showToast(BuildContext context) {
    showToast(
      'Book Id Coppied',
      position: ToastPosition.center,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 13.0,
      textStyle: TextStyle(fontSize: 15, color: Colors.white),
      animationBuilder: const Miui10AnimBuilder(),
    );
  }

  void pickCoverImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      Uint8List? uploadFile = result.files.single.bytes;

      Reference reference =
          FirebaseStorage.instance.ref().child("Offers").child(offerId!);

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
      appBar: AppBar(
        title: Text(
          'Remedies LifeTime Admin Web',
          style: TextStyle(color: constantColors.blackColor),
        ),
        backgroundColor: constantColors.mainColor,
        iconTheme: IconThemeData(color: constantColors.whiteColor),
      ),
      backgroundColor: constantColors.whiteColor,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text('View All User!'),
                onTap: () {
                  context.vRouter.to("/allUsers");
                },
              ),
              ListTile(
                  title: Text('Upload Your Products!'),
                  onTap: () {
                    context.vRouter.to("/upload");
                  }),
              ListTile(
                title: Text("Offers!"),
                onTap: () {
                  context.vRouter.to("/offers");
                },
              ),
              Divider(),
              ListTile(
                  title: Text('LogOut as Admin'),
                  onTap: () {
                    firebaseAuthOperations.logOutasAdmin(context);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: getAllBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Responsive(
                mobile: Container(
                  child: bookData.length == 0
                      ? Container(
                          child: Center(
                          child: Image.asset("assets/Images/home.gif"),
                        ))
                      : GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: bookData.length,
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        height: 10.h,
                                        decoration: BoxDecoration(
                                            color: constantColors.greyColor,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    bookData[index]
                                                        ["bookCoverImageUrl"]),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(2.sp)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        bookData[index]["bookName"],
                                        style: GoogleFonts.nunito(
                                            color: constantColors.blackColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            bookData[index]["bookMrp"],
                                            style: GoogleFonts.nunito(
                                                color:
                                                    constantColors.blackColor,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: constantColors.mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        2.sp)),
                                            child: Text(
                                              bookData[index]["bookPrice"],
                                              style: GoogleFonts.nunito(
                                                  color:
                                                      constantColors.blackColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: TextButton(
                                              onPressed: () {
                                                print(
                                                    "Book Id :${bookData[index]["bookId"]}");
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: ManageProduct(
                                                          bookId:
                                                              bookData[index]
                                                                  ["bookId"],
                                                        ),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                              child: Text("Edit book")),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: TextButton(
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 10,
                                                                sigmaY: 10),
                                                        child: Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 10,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(2.0
                                                                            .w))),
                                                            child: Container(
                                                                height: 60.0.w,
                                                                width: 40.0.h,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 2.0.w,
                                                                              horizontal: 3.0.h),
                                                                          child:
                                                                              Text(
                                                                            "Upload Cover Imahe",
                                                                            style: GoogleFonts.montserrat(
                                                                                color: Color(0xff394C73),
                                                                                fontSize: 12.0.sp,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(
                                                                              bottom: 0.5.w,
                                                                              left: 3.0.h),
                                                                          child:
                                                                              Text(
                                                                            "Cover Image",
                                                                            style: GoogleFonts.montserrat(
                                                                                color: Colors.blueGrey,
                                                                                fontSize: 6.0.sp,
                                                                                fontWeight: FontWeight.w300),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 1.0.w,
                                                                              horizontal: 3.0.h),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                20.0.w,
                                                                            child:
                                                                                Center(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  pickCoverImage();
                                                                                },
                                                                                child: Icon(
                                                                                  FontAwesomeIcons.solidFolderOpen,
                                                                                  size: 25.0.sp,
                                                                                  color: ConstantColors.greenColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.grey.shade100,
                                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                border: Border.all(color: Colors.grey[350]!)),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(right: 3.0.h, top: 2.0.w),
                                                                              child: ElevatedButton(
                                                                                  style: ButtonStyle(elevation: MaterialStateProperty.all(10), padding: MaterialStateProperty.all(EdgeInsets.all(2.0.h)), backgroundColor: MaterialStateProperty.all(ConstantColors.blueColor), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.0.h))))),
                                                                                  onPressed: () async {
                                                                                    var offerId = Uuid().v4();
                                                                                    await FirebaseFirestore.instance.collection("Offers").doc(offerId).set({
                                                                                      "type": "BookOffer",
                                                                                      "offerId": offerId,
                                                                                      "bookId": bookData[index]["bookId"],
                                                                                      "imageUrl": imageUrl!
                                                                                    }).whenComplete(() {
                                                                                      Navigator.pop(context);
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return AlertDialog(
                                                                                              content: Text("Offer Created Successfully"),
                                                                                              title: Text("Succes"),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Text("oK"))
                                                                                              ],
                                                                                            );
                                                                                          });
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    "Upload",
                                                                                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 8.0.sp, fontWeight: FontWeight.w300),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        )
                                                                      ]),
                                                                ))),
                                                      );
                                                    });
                                              },
                                              child: Text("Create Offer")),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(05.sp),
                                      margin: EdgeInsets.all(05.sp),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(3.sp)),
                                      child: InkWell(
                                        onTap: () async {
                                          print("copping bookId ....");
                                          await Clipboard.setData(ClipboardData(
                                                  text:
                                                      '${bookData[index]["bookId"]}'))
                                              .then((value) {
                                            print("coppied");
                                            _showToast(context);
                                            // Fluttertoast.showToast(
                                            //     msg:
                                            //         "Book Id Coppied",
                                            //     toastLength: Toast.LENGTH_SHORT,
                                            //     gravity: ToastGravity.CENTER,
                                            //     timeInSecForIosWeb: 1,
                                            //     backgroundColor: Colors.red,
                                            //     textColor: Colors.white,
                                            //     fontSize: 16.0);
                                          });
                                        },
                                        child: Text(
                                          '${bookData[index]["bookId"]}',
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                        ),
                                        // child: Flexible(
                                        //   child: Text(
                                        //     '${bookData[index]["bookId"]}',
                                        //     maxLines: 2,
                                        //     softWrap: true,
                                        //     overflow: TextOverflow.clip,
                                        //   ),
                                        // ),
                                      ),
                                    ),
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
                                  crossAxisCount: 2),
                        ),
                ),
                tablet: Container(
                  child: bookData.length == 0
                      ? Container(
                          child: Center(
                          child: Image.asset("assets/Images/home.gif"),
                        ))
                      : GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: bookData.length,
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        height: 15.h,
                                        decoration: BoxDecoration(
                                            color: constantColors.greyColor,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    bookData[index]
                                                        ["bookCoverImageUrl"]),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(2.sp)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        bookData[index]["bookName"],
                                        style: GoogleFonts.nunito(
                                            color: constantColors.blackColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            bookData[index]["bookMrp"],
                                            style: GoogleFonts.nunito(
                                                color:
                                                    constantColors.blackColor,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: constantColors.mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        2.sp)),
                                            child: Text(
                                              bookData[index]["bookPrice"],
                                              style: GoogleFonts.nunito(
                                                  color:
                                                      constantColors.blackColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: TextButton(
                                              onPressed: () {
                                                print(
                                                    "Book Id :${bookData[index]["bookId"]}");
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: ManageProduct(
                                                          bookId:
                                                              bookData[index]
                                                                  ["bookId"],
                                                        ),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                              child: Text("Edit book")),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: TextButton(
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 10,
                                                                sigmaY: 10),
                                                        child: Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 10,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(2.0
                                                                            .w))),
                                                            child: Container(
                                                                height: 0.0.w,
                                                                width: 40.0.h,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 2.0.w,
                                                                              horizontal: 3.0.h),
                                                                          child:
                                                                              Text(
                                                                            "Upload Cover Imahe",
                                                                            style: GoogleFonts.montserrat(
                                                                                color: Color(0xff394C73),
                                                                                fontSize: 12.0.sp,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(
                                                                              bottom: 0.5.w,
                                                                              left: 3.0.h),
                                                                          child:
                                                                              Text(
                                                                            "Cover Image",
                                                                            style: GoogleFonts.montserrat(
                                                                                color: Colors.blueGrey,
                                                                                fontSize: 6.0.sp,
                                                                                fontWeight: FontWeight.w300),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 1.0.w,
                                                                              horizontal: 3.0.h),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                20.0.w,
                                                                            child:
                                                                                Center(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  pickCoverImage();
                                                                                },
                                                                                child: Icon(
                                                                                  FontAwesomeIcons.solidFolderOpen,
                                                                                  size: 25.0.sp,
                                                                                  color: ConstantColors.greenColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.grey.shade100,
                                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                border: Border.all(color: Colors.grey[350]!)),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(right: 3.0.h, top: 2.0.w),
                                                                              child: ElevatedButton(
                                                                                  style: ButtonStyle(elevation: MaterialStateProperty.all(10), padding: MaterialStateProperty.all(EdgeInsets.all(2.0.h)), backgroundColor: MaterialStateProperty.all(ConstantColors.blueColor), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.0.h))))),
                                                                                  onPressed: () async {
                                                                                    var offerId = Uuid().v4();
                                                                                    await FirebaseFirestore.instance.collection("Offers").doc(offerId).set({
                                                                                      "type": "BookOffer",
                                                                                      "offerId": offerId,
                                                                                      "bookId": bookData[index]["bookId"],
                                                                                      "imageUrl": imageUrl!
                                                                                    }).whenComplete(() {
                                                                                      Navigator.pop(context);
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return AlertDialog(
                                                                                              content: Text("Offer Created Successfully"),
                                                                                              title: Text("Succes"),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Text("oK"))
                                                                                              ],
                                                                                            );
                                                                                          });
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    "Upload",
                                                                                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 8.0.sp, fontWeight: FontWeight.w300),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        )
                                                                      ]),
                                                                ))),
                                                      );
                                                    });
                                                // showDialog(
                                                //     context: context,
                                                //     builder: (context) {
                                                //       return AlertDialog(
                                                //           content: Text(
                                                //               "Do you want to create offer for this book!"),
                                                //           title: Text(
                                                //               "Alert Dialog"),
                                                //           actions: [
                                                //             TextButton(
                                                //               onPressed:
                                                //                   () async {
                                                //                 var offerId =
                                                //                     Uuid().v4();
                                                //                 await FirebaseFirestore
                                                //                     .instance
                                                //                     .collection(
                                                //                         "Offers")
                                                //                     .doc(
                                                //                         offerId)
                                                //                     .set({
                                                //                   "type":
                                                //                       "BookOffer",
                                                //                   "offerId":
                                                //                       offerId,
                                                //                   "bookId": bookData[
                                                //                           index]
                                                //                       [
                                                //                       "bookId"],
                                                //                   "imageUrl": bookData[
                                                //                           index]
                                                //                       [
                                                //                       "bookCoverImageUrl"]
                                                //                 }).whenComplete(
                                                //                         () {
                                                //                   Navigator.pop(
                                                //                       context);
                                                //                   showDialog(
                                                //                       context:
                                                //                           context,
                                                //                       builder:
                                                //                           (context) {
                                                //                         return AlertDialog(
                                                //                           content:
                                                //                               Text("Offer Created Successfully"),
                                                //                           title:
                                                //                               Text("Succes"),
                                                //                           actions: [
                                                //                             TextButton(
                                                //                                 onPressed: () {
                                                //                                   Navigator.pop(context);
                                                //                                 },
                                                //                                 child: Text("oK"))
                                                //                           ],
                                                //                         );
                                                //                       });
                                                //                 });
                                                //               },
                                                //               child: Text(
                                                //                   "Create Offer!"),
                                                //             )
                                                //           ]);
                                                //     });
                                              },
                                              child: Text("Create Offer")),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(05.sp),
                                      margin: EdgeInsets.all(05.sp),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(3.sp)),
                                      child: InkWell(
                                        onTap: () async {
                                          print("copping bookId ....");
                                          await Clipboard.setData(ClipboardData(
                                                  text:
                                                      '${bookData[index]["bookId"]}'))
                                              .then((value) {
                                            print("coppied");
                                            _showToast(context);
                                            // Fluttertoast.showToast(
                                            //     msg:
                                            //         "Book Id Coppied",
                                            //     toastLength: Toast.LENGTH_SHORT,
                                            //     gravity: ToastGravity.CENTER,
                                            //     timeInSecForIosWeb: 1,
                                            //     backgroundColor: Colors.red,
                                            //     textColor: Colors.white,
                                            //     fontSize: 16.0);
                                          });
                                        },
                                        child: Text(
                                          '${bookData[index]["bookId"]}',
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                        ),
                                        // child: Flexible(
                                        //   child: Text(
                                        //     '${bookData[index]["bookId"]}',
                                        //     maxLines: 2,
                                        //     softWrap: true,
                                        //     overflow: TextOverflow.clip,
                                        //   ),
                                        // ),
                                      ),
                                    ),
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
                                  crossAxisCount: 3),
                        ),
                ),
                desktop: Container(
                  child: bookData.length == 0
                      ? Container(
                          child: Center(
                          child: Image.asset("assets/Images/home.gif"),
                        ))
                      : GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: bookData.length,
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        height: 15.h,
                                        decoration: BoxDecoration(
                                            color: constantColors.greyColor,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    bookData[index]
                                                        ["bookCoverImageUrl"]),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(2.sp)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        bookData[index]["bookName"],
                                        style: GoogleFonts.nunito(
                                            color: constantColors.blackColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            bookData[index]["bookMrp"],
                                            style: GoogleFonts.nunito(
                                                color:
                                                    constantColors.blackColor,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: constantColors.mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        2.sp)),
                                            child: Text(
                                              bookData[index]["bookPrice"],
                                              style: GoogleFonts.nunito(
                                                  color:
                                                      constantColors.blackColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: TextButton(
                                              onPressed: () {
                                                print(
                                                    "Book Id :${bookData[index]["bookId"]}");
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: ManageProduct(
                                                          bookId:
                                                              bookData[index]
                                                                  ["bookId"],
                                                        ),
                                                        type: PageTransitionType
                                                            .fade));
                                              },
                                              child: Text("Edit book")),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: TextButton(
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 10,
                                                                sigmaY: 10),
                                                        child: Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 10,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(2.0
                                                                            .w))),
                                                            child: Container(
                                                                height: 60.0.w,
                                                                width: 40.0.h,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 2.0.w,
                                                                              horizontal: 3.0.h),
                                                                          child:
                                                                              Text(
                                                                            "Upload Cover Imahe",
                                                                            style: GoogleFonts.montserrat(
                                                                                color: Color(0xff394C73),
                                                                                fontSize: 12.0.sp,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(
                                                                              bottom: 0.5.w,
                                                                              left: 3.0.h),
                                                                          child:
                                                                              Text(
                                                                            "Cover Image",
                                                                            style: GoogleFonts.montserrat(
                                                                                color: Colors.blueGrey,
                                                                                fontSize: 6.0.sp,
                                                                                fontWeight: FontWeight.w300),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 1.0.w,
                                                                              horizontal: 3.0.h),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                20.0.w,
                                                                            child:
                                                                                Center(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  pickCoverImage();
                                                                                },
                                                                                child: Icon(
                                                                                  FontAwesomeIcons.solidFolderOpen,
                                                                                  size: 25.0.sp,
                                                                                  color: ConstantColors.greenColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.grey.shade100,
                                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                border: Border.all(color: Colors.grey[350]!)),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(right: 3.0.h, top: 2.0.w),
                                                                              child: ElevatedButton(
                                                                                  style: ButtonStyle(elevation: MaterialStateProperty.all(10), padding: MaterialStateProperty.all(EdgeInsets.all(2.0.h)), backgroundColor: MaterialStateProperty.all(ConstantColors.blueColor), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.0.h))))),
                                                                                  onPressed: () async {
                                                                                    var offerId = Uuid().v4();
                                                                                    await FirebaseFirestore.instance.collection("Offers").doc(offerId).set({
                                                                                      "type": "BookOffer",
                                                                                      "offerId": offerId,
                                                                                      "bookId": bookData[index]["bookId"],
                                                                                      "imageUrl": imageUrl!
                                                                                    }).whenComplete(() {
                                                                                      Navigator.pop(context);
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return AlertDialog(
                                                                                              content: Text("Offer Created Successfully"),
                                                                                              title: Text("Succes"),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Text("oK"))
                                                                                              ],
                                                                                            );
                                                                                          });
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    "Upload",
                                                                                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 8.0.sp, fontWeight: FontWeight.w300),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              2.0.w,
                                                                        )
                                                                      ]),
                                                                ))),
                                                      );
                                                    });
                                                // showDialog(
                                                //     context: context,
                                                //     builder: (context) {
                                                //       return AlertDialog(
                                                //         content: Text(
                                                //             "Do you want to create offer for this book!"),
                                                //         title: Text(
                                                //             "Alert Dialog"),
                                                //         actions: [
                                                //           TextButton(
                                                //               onPressed:
                                                //                   () async {
                                                //                 var offerId =
                                                //                     Uuid().v4();
                                                //                 await FirebaseFirestore
                                                //                     .instance
                                                //                     .collection(
                                                //                         "Offers")
                                                //                     .doc(
                                                //                         offerId)
                                                //                     .set({
                                                //                   "type":
                                                //                       "BookOffer",
                                                //                   "offerId":
                                                //                       offerId,
                                                //                   "bookId": bookData[
                                                //                           index]
                                                //                       [
                                                //                       "bookId"],
                                                //                   "imageUrl": bookData[
                                                //                           index]
                                                //                       [
                                                //                       "bookCoverImageUrl"]
                                                //                 }).whenComplete(
                                                //                         () {
                                                //                   Navigator.pop(
                                                //                       context);
                                                //                   showDialog(
                                                //                       context:
                                                //                           context,
                                                //                       builder:
                                                //                           (context) {
                                                //                         return AlertDialog(
                                                //                           content:
                                                //                               Text("Offer Created Successfully"),
                                                //                           title:
                                                //                               Text("Succes"),
                                                //                           actions: [
                                                //                             TextButton(
                                                //                                 onPressed: () {
                                                //                                   Navigator.pop(context);
                                                //                                 },
                                                //                                 child: Text("oK"))
                                                //                           ],
                                                //                         );
                                                //                       });
                                                //                 });
                                                //               },
                                                //               child: Text(
                                                //                   "Create Offer"))
                                                //         ],
                                                //       );
                                                //     });
                                              },
                                              child: Text("Create Offer")),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(05.sp),
                                      margin: EdgeInsets.all(05.sp),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(3.sp)),
                                      child: InkWell(
                                        onTap: () async {
                                          print("copping bookId ....");
                                          await Clipboard.setData(ClipboardData(
                                                  text:
                                                      '${bookData[index]["bookId"]}'))
                                              .then((value) {
                                            print("coppied");
                                            _showToast(context);
                                            // Fluttertoast.showToast(
                                            //     msg:
                                            //         "Book Id Coppied",
                                            //     toastLength: Toast.LENGTH_SHORT,
                                            //     gravity: ToastGravity.CENTER,
                                            //     timeInSecForIosWeb: 1,
                                            //     backgroundColor: Colors.red,
                                            //     textColor: Colors.white,
                                            //     fontSize: 16.0);
                                          });
                                        },
                                        child: Text(
                                          '${bookData[index]["bookId"]}',
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                        ),
                                        // child: Flexible(
                                        //   child: Text(
                                        //     '${bookData[index]["bookId"]}',
                                        //     maxLines: 2,
                                        //     softWrap: true,
                                        //     overflow: TextOverflow.clip,
                                        //   ),
                                        // ),
                                      ),
                                    ),
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
                        ),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Image.asset("assets/Images/home.gif"),
                ),
              );
            }
          }),
    );
  }
}

class HomeMobile extends StatefulWidget {
  const HomeMobile({Key? key}) : super(key: key);

  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
