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

class ManageProduct extends StatefulWidget {
  final bookId;
  const ManageProduct({Key? key, required this.bookId}) : super(key: key);

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  var bookData;

  TextEditingController collectionNameController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookDiscrController = TextEditingController();
  TextEditingController bookPriceController = TextEditingController();

  String? imageUrl;

  String? bookPreViewUrl;
  String? bookFullUrl;

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
          .child('CoverImages')
          .child(widget.bookId!);

      final UploadTask uploadTask = reference.putData(uploadFile!);
      uploadTask.whenComplete(() async {
        String coverImage = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = coverImage;
        });
      });
    }
  }

  void pickPreviewFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: ['epub'],
    );
    if (result != null) {
      Uint8List? uploadFile = result.files.single.bytes;

      String? filename = result.files.single.name;

      Reference reference = FirebaseStorage.instance
          .ref()
          .child('Books')
          .child(widget.bookId!)
          .child("Preview");

      final UploadTask uploadTask = reference.putData(uploadFile!);
      uploadTask.whenComplete(() async {
        String previewbookFile = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          bookPreViewUrl = previewbookFile;
        });
      });
    }
  }

  void pickFullFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: ['epub'],
    );
    if (result != null) {
      Uint8List? uploadFile = result.files.single.bytes;

      String? filename = result.files.single.name;

      Reference reference = FirebaseStorage.instance
          .ref()
          .child('Books')
          .child(widget.bookId!)
          .child('Full');

      final UploadTask uploadTask = reference.putData(uploadFile!);
      uploadTask.whenComplete(() async {
        String fullbookFile = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          bookFullUrl = fullbookFile;
        });
      });
    }
  }

  Future getBookDetailById() async {
    await FirebaseFirestore.instance
        .collection(BOOK_COLLECTION)
        .doc(widget.bookId)
        .get()
        .then((value) {
      bookData = value.data();
    });
  }

  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      appBar: AppBar(
          title: Text(
            'Manage Product',
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
              icon: Icon(EvaIcons.save),
              onPressed: () {},
            )
          ]),
      body: FutureBuilder(
        future: getBookDetailById(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Responsive(
                mobile: Container(
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
                                child: Stack(
                                 alignment: Alignment.bottomRight,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        pickCoverImage();
                                      },
                                      icon: Icon(
                                        EvaIcons.edit2,
                                        size: 20.sp,
                                        color: constantColors.mainColor,
                                      ),
                                    ),
                                  
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: constantColors.greyColor,
                                    borderRadius: BorderRadius.circular(10.sp),
                                    border: Border.all(
                                      color: constantColors.greyColor,
                                    ),
                                    image: DecorationImage(
                                        image:imageUrl != null ? NetworkImage(imageUrl!) :  NetworkImage(
                                            bookData["bookCoverImageUrl"])
                                            
                                            )),
                              )),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 10.h,
                                    width: 50.w,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            pickPreviewFile();
                                          },
                                          icon: Icon(
                                            EvaIcons.fileAdd,
                                            size: 20.sp,
                                            color: constantColors.mainColor,
                                          ),
                                        ),
                                        hSizedBox2,
                                        bookPreViewUrl != null
                                            ? Text(
                                                "Previwe Book Added",
                                                style: GoogleFonts.nunito(
                                                    color: Colors.black,
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            : Text(
                                                "Add Previwe Book",
                                                style: GoogleFonts.nunito(
                                                    color: Colors.black,
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.sp),
                                        color: constantColors.greyColor)),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Container(
                                    height: 10.h,
                                    width: 50.w,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            pickFullFile();
                                          },
                                          icon: Icon(
                                            EvaIcons.fileAdd,
                                            size: 20.sp,
                                            color: constantColors.mainColor,
                                          ),
                                        ),
                                        hSizedBox2,
                                        bookFullUrl != null
                                            ? Text(
                                                "Full Book Added",
                                                style: GoogleFonts.nunito(
                                                    color: Colors.black,
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            : Text(
                                                "Add Full Book",
                                                style: GoogleFonts.nunito(
                                                    color: Colors.black,
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.sp),
                                        color: constantColors.greyColor)),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: hBox2, top: vBox2),
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
                                  hintText: "Herbal remedies for life.",
                                  hintStyle: GoogleFonts.nunito(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 40),
                            child: TextField(
                              controller: bookPriceController,
                              decoration: InputDecoration(
                                  labelText: "Book Price",
                                  labelStyle: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.normal),
                                  hintText: "ex: 100\$ ",
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
                    ],
                  ),
                ),
                tablet: Container(),
                desktop: Container(),
              ),
            );
          } else {
            return Text("Not done");
          }
        },
      ),
    );
  }
}
