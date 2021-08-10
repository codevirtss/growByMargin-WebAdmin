import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Screens/Auth/LoginWidget.dart';
import 'package:growbymargin_webadmin/Services/FirebaseAuth.dart';
import 'package:growbymargin_webadmin/Utils/Dimensions.dart';
import 'package:growbymargin_webadmin/Utils/Responsive.dart';
import 'package:growbymargin_webadmin/Utils/Strigns.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class UploadProduct extends StatefulWidget {
  const UploadProduct({Key? key}) : super(key: key);

  @override
  _UploadProductState createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  TextEditingController collectionNameController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookDiscrController = TextEditingController();
  TextEditingController bookPriceController = TextEditingController();

  String? imageUrl;
  String? bookId = Uuid().v4();
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
          .child("Books")
          .child(bookId!)
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

  void pickPreviewFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      Uint8List? uploadFile = result.files.single.bytes;

      String? filename = result.files.single.name;

      Reference reference = FirebaseStorage.instance
          .ref()
          .child('Books')
          .child(bookId!)
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
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      Uint8List? uploadFile = result.files.single.bytes;

      String? filename = result.files.single.name;

      Reference reference = FirebaseStorage.instance
          .ref()
          .child('Books')
          .child(bookId!)
          .child("Full");

      final UploadTask uploadTask = reference.putData(uploadFile!);
      uploadTask.whenComplete(() async {
        String fullbookFile = await uploadTask.snapshot.ref.getDownloadURL();
        setState(() {
          bookFullUrl = fullbookFile;
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
              onPressed: () async {
                if (collectionNameController.text.isNotEmpty &&
                    bookNameController.text.isNotEmpty &&
                    bookDiscrController.text.isNotEmpty &&
                    bookPriceController.text.isNotEmpty &&
                    bookPreViewUrl!.isNotEmpty &&
                    bookFullUrl!.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection(BOOK_COLLECTION)
                      .doc(bookId!)
                      .set({
                    "bookCollectionName": collectionNameController.text,
                    "bookName": bookNameController.text,
                    "bookDescription": bookDiscrController.text,
                    "bookCoverImageUrl": imageUrl!,
                    "bookPrice": bookPriceController.text,
                    "bookPreviewUrl": bookPreViewUrl!,
                    "fullBookUrl": bookFullUrl!,
                    "bookId": bookId!,
                  }).whenComplete(() {
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
                  });
                }
                {
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
              icon: Icon(EvaIcons.uploadOutline),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Responsive(
          mobile: Row(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                  Column(
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
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "Add Previwe Book",
                                      style: GoogleFonts.nunito(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.sp),
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
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "Add Full Book",
                                      style: GoogleFonts.nunito(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.sp),
                              color: constantColors.greyColor)),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
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
          tablet: Column(
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
                            child: imageUrl == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                   Column(
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
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Previwe Book Added",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Add Previwe Book",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                color: constantColors.greyColor)),
                        SizedBox(
                          height: 2.h,
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
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Full Book Added",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Add Full Book",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                color: constantColors.greyColor)),
                      ],
                    ),
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
                    Column(
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
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Previwe Book Added",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Add Previwe Book",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                color: constantColors.greyColor)),
                        SizedBox(
                          height: 2.h,
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
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Full Book Added",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Add Full Book",
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                color: constantColors.greyColor)),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
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
                      height: 10.0.h,
                      width: 50.0.h,
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
                      height: 10.0.h,
                      width: 50.0.h,
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
                      height: 10.0.h,
                      width: 50.0.h,
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
                      // height: 10.0.h,
                      width: 50.0.h,
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
                )
              ],
            ),
          ),
        )));
  }
}


class UploadMobile extends StatelessWidget {
  final imageUrl;
  final collectionName;
  final bookName;
  final bookPrice;
  final bookDiscr;
  final onpress;
  final bookPreViewUrl;
  final bookFullUrl;
  const UploadMobile({
    Key? key,
    this.imageUrl,
    this.collectionName,
    this.bookName,
    this.bookPrice,
    this.bookDiscr,
    this.onpress,
    this.bookPreViewUrl,
    this.bookFullUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      child: imageUrl == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: onpress,
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
                            )
                          : Image.network(imageUrl!)),
                  decoration: BoxDecoration(
                      color: constantColors.greyColor,
                      borderRadius: BorderRadius.circular(10.sp)),
                )),
            Column(
              children: [
                Container(
                  child: Text(
                    """Upload coverImage fro
your product""",
                    style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600),
                  ),
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
            controller: collectionName,
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
            controller: bookName,
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
            controller: bookPrice,
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
            controller: bookDiscr,
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
    );
  }
}

class UploadTab extends StatelessWidget {
  final imageUrl;
  final collectionName;
  final bookName;
  final bookPrice;
  final bookDiscr;
  final onpress;
  final bookPreViewUrl;
  final bookFullUrl;
  const UploadTab({
    Key? key,
    this.imageUrl,
    this.collectionName,
    this.bookName,
    this.bookPrice,
    this.bookDiscr,
    this.onpress,
    this.bookPreViewUrl,
    this.bookFullUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      child: imageUrl == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: onpress,
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
                            )
                          : Image.network(imageUrl!)),
                  decoration: BoxDecoration(
                      color: constantColors.greyColor,
                      borderRadius: BorderRadius.circular(10.sp)),
                )),
            Column(
              children: [
                Container(
                  child: Text(
                    """Upload coverImage fro
your product""",
                    style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600),
                  ),
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
            controller: collectionName,
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
            controller: bookName,
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
            controller: bookPrice,
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
            controller: bookDiscr,
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
    );
  }
}
