import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Screens/Product/ManageProduct/manageProduct.dart';
import 'package:growbymargin_webadmin/Services/FirebaseAuth.dart';
import 'package:growbymargin_webadmin/Utils/Responsive.dart';
import 'package:growbymargin_webadmin/Utils/Strigns.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
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
  Future getAllBooks() async {
    await FirebaseFirestore.instance
        .collection(BOOK_COLLECTION)
        .get()
        .then((value) {
      bookData = value.docs;
    });
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
                                                      return AlertDialog(
                                                        content: Text(
                                                            "Do you want to create offer for this book!"),
                                                        title: Text(
                                                            "Alert Dialog"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                var offerId =
                                                                    Uuid().v4();
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Offers")
                                                                    .doc(
                                                                        offerId)
                                                                    .set({
                                                                  "type":
                                                                      "BookOffer",
                                                                  "offerId":
                                                                      offerId,
                                                                  "bookId": bookData[
                                                                          index]
                                                                      [
                                                                      "bookId"],
                                                                  "imageUrl": bookData[
                                                                          index]
                                                                      [
                                                                      "bookCoverImageUrl"]
                                                                }).whenComplete(
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Text("Offer Created Successfully"),
                                                                          title:
                                                                              Text("Succes"),
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
                                                                  "Create Offer"))
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Text("Create Offer")),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(3.sp)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () async {
                                              print("copping bookId ....");
                                              await Clipboard.setData(ClipboardData(
                                                  text:
                                                      '${bookData[index]["bookId"]}'));
                                            },
                                            child: Flexible(
                                              child: Text(
                                                '${bookData[index]["bookId"]}',
                                                maxLines: 2,
                                                softWrap: false,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                                height: 30.h,
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
                                                      return AlertDialog(
                                                          content: Text(
                                                              "Do you want to create offer for this book!"),
                                                          title: Text(
                                                              "Alert Dialog"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                var offerId =
                                                                    Uuid().v4();
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Offers")
                                                                    .doc(
                                                                        offerId)
                                                                    .set({
                                                                  "type":
                                                                      "BookOffer",
                                                                  "offerId":
                                                                      offerId,
                                                                  "bookId": bookData[
                                                                          index]
                                                                      [
                                                                      "bookId"],
                                                                  "imageUrl": bookData[
                                                                          index]
                                                                      [
                                                                      "bookCoverImageUrl"]
                                                                }).whenComplete(
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Text("Offer Created Successfully"),
                                                                          title:
                                                                              Text("Succes"),
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
                                                                  "Create Offer!"),
                                                            )
                                                          ]);
                                                    });
                                              },
                                              child: Text("Create Offer")),
                                        ),
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
                                height: 30.h,
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
                                                      return AlertDialog(
                                                        content: Text(
                                                            "Do you want to create offer for this book!"),
                                                        title: Text(
                                                            "Alert Dialog"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                var offerId =
                                                                    Uuid().v4();
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Offers")
                                                                    .doc(
                                                                        offerId)
                                                                    .set({
                                                                  "type":
                                                                      "BookOffer",
                                                                  "offerId":
                                                                      offerId,
                                                                  "bookId": bookData[
                                                                          index]
                                                                      [
                                                                      "bookId"],
                                                                  "imageUrl": bookData[
                                                                          index]
                                                                      [
                                                                      "bookCoverImageUrl"]
                                                                }).whenComplete(
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          content:
                                                                              Text("Offer Created Successfully"),
                                                                          title:
                                                                              Text("Succes"),
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
                                                                  "Create Offer"))
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Text("Create Offer")),
                                        ),
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
