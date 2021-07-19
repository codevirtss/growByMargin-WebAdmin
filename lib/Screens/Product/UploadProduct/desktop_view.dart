import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Utils/Strigns.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';

import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:vrouter/vrouter.dart';

class DesktopView extends StatefulWidget {
  const DesktopView({Key? key}) : super(key: key);

  @override
  _DesktopViewState createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
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
      allowedExtensions: ['epub'],
    );
    if (result != null) {
      Uint8List? uploadFile = result.files.single.bytes;

      //   String? filename = result.files.single.name;

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
      allowedExtensions: ['epub'],
    );
    if (result != null) {
      Uint8List? uploadFile = result.files.single.bytes;

      //  String? filename = result.files.single.name;

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
        backgroundColor: Colors.white,
        body: Container(
          height: 100.0.w,
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.0.w,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.5.h, vertical: 2.0.w),
                        child: Text(
                          "Post New Book",
                          style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.0.h, vertical: 4.0.w),
                        decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0.w))),
                        height: 70.0.w,
                        width: 40.0.h,
                        child: Container(
                          margin: EdgeInsets.all(1),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 12.0.w),
                                child: Text("Upload Book Cover Image",
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey,
                                      fontSize: 6.0.sp,
                                    )),
                              ),
                              SizedBox(
                                height: 7.0.w,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.0.w),
                                child: Text("Drag And Drop Files Here",
                                    style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        fontSize: 9.0.sp,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 3.0.h),
                                child: Text("OR",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 9.0.sp,
                                        fontWeight: FontWeight.w300)),
                              ),
                              ElevatedButton.icon(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(3.0.w)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xffFE585A))),
                                  onPressed: () {
                                    showDialog(
                                        //barrierColor: Colors.grey[200]!.withOpacity(0.2),

                                        //    barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Dialog(
                                                backgroundColor: Colors.white,
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                2.0.w))),
                                                child: Container(
                                                  height: 80.0.w,
                                                  width: 40.0.h,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 2.0.w,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0.w,
                                                                  horizontal:
                                                                      3.0.h),
                                                          child: Text(
                                                            "Create a Book",
                                                            style: GoogleFonts.nunito(
                                                                color: Color(
                                                                    0xff394C73),
                                                                fontSize:
                                                                    12.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2.0.w,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 0.5.w,
                                                                  left: 3.0.h),
                                                          child: Text(
                                                            "Book Collection Name",
                                                            style: GoogleFonts.nunito(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize:
                                                                    6.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.0.w,
                                                                    horizontal:
                                                                        3.0.h),
                                                            child: TextField(
                                                              controller:
                                                                  collectionNameController,
                                                              style: GoogleFonts.nunito(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      8.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                              decoration:
                                                                  InputDecoration(
                                                                alignLabelWithHint:
                                                                    false,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .never,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(2.0
                                                                            .h),
                                                                labelText:
                                                                    "Click to Enter Book Title",
                                                                labelStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                hintText:
                                                                    "Eg:- Herbal Remedies",
                                                                hintStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                errorBorder:
                                                                    InputBorder
                                                                        .none,
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.grey[
                                                                            350]!,
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff394C73),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff394C73),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                              ),
                                                            )),
                                                        SizedBox(
                                                          height: 4.0.w,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 0.5.w,
                                                                  left: 3.0.h),
                                                          child: Text(
                                                            "Book Title",
                                                            style: GoogleFonts.nunito(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize:
                                                                    6.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.0.w,
                                                                    horizontal:
                                                                        3.0.h),
                                                            child: TextField(
                                                              controller:
                                                                  bookNameController,
                                                              style: GoogleFonts.nunito(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      8.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                              decoration:
                                                                  InputDecoration(
                                                                alignLabelWithHint:
                                                                    false,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .never,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(2.0
                                                                            .h),
                                                                labelText:
                                                                    "Click to Enter Book Title",
                                                                labelStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                hintText:
                                                                    "Eg:- Herbal Remedies",
                                                                hintStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                errorBorder:
                                                                    InputBorder
                                                                        .none,
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.grey[
                                                                            350]!,
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff394C73),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff394C73),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                              ),
                                                            )),
                                                        SizedBox(
                                                          height: 4.0.w,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 0.5.w,
                                                                  left: 3.0.h),
                                                          child: Text(
                                                            "Book Price",
                                                            style: GoogleFonts.nunito(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize:
                                                                    6.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.0.w,
                                                                    horizontal:
                                                                        3.0.h),
                                                            child: TextField(
                                                              controller:
                                                                  bookPriceController,
                                                              style: GoogleFonts.nunito(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      8.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                              decoration:
                                                                  InputDecoration(
                                                                suffixText:
                                                                    "INR",
                                                                suffixStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                alignLabelWithHint:
                                                                    false,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .never,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(2.0
                                                                            .h),
                                                                labelText:
                                                                    "Click to Enter Book Price",
                                                                labelStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                hintText:
                                                                    "Eg:- 100",
                                                                hintStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                errorBorder:
                                                                    InputBorder
                                                                        .none,
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.grey[
                                                                            350]!,
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff394C73),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff394C73),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                              ),
                                                            )),
                                                        SizedBox(
                                                          height: 4.0.h,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 0.5.w,
                                                                  left: 3.0.h),
                                                          child: Text(
                                                            "Book Description",
                                                            style: GoogleFonts.nunito(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize:
                                                                    6.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.0.w,
                                                                    horizontal:
                                                                        3.0.h),
                                                            child: TextField(
                                                              controller:
                                                                  bookDiscrController,
                                                              style: GoogleFonts.nunito(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      8.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                              maxLines: 100,
                                                              minLines: 1,
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                isCollapsed:
                                                                    true,
                                                                alignLabelWithHint:
                                                                    false,
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .never,
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            2.0
                                                                                .w,
                                                                        vertical:
                                                                            2.0.w),
                                                                labelText:
                                                                    "Click to Enter Book Description",
                                                                labelStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                hintText:
                                                                    "Eg:- This book is specially designed for herbal remedies that can be followed at home",
                                                                hintStyle: GoogleFonts.nunito(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        8.0.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                errorBorder:
                                                                    InputBorder
                                                                        .none,
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors.grey[
                                                                            350]!,
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff394C73),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                disabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color(
                                                                            0xff394C73),
                                                                        width:
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                              ),
                                                            )),
                                                        SizedBox(
                                                          height: 4.0.h,
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          3.0.h,
                                                                      top: 2.0
                                                                          .w),
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          padding: MaterialStateProperty.all(EdgeInsets.all(2.0
                                                                              .h)),
                                                                          backgroundColor: MaterialStateProperty.all(ConstantColors
                                                                              .greenColor),
                                                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(1.0
                                                                                  .w))))),
                                                                      onPressed:
                                                                          () {
                                                                        // context.vRouter.pop();
                                                                        showDialog(
                                                                            //barrierColor: Colors.grey[200]!.withOpacity(0.2),

                                                                            //    barrierDismissible: false,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return BackdropFilter(
                                                                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                                                child: Dialog(
                                                                                    backgroundColor: Colors.white,
                                                                                    elevation: 10,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0.w))),
                                                                                    child: Container(
                                                                                        height: 80.0.w,
                                                                                        width: 40.0.h,
                                                                                        child: SingleChildScrollView(
                                                                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                            SizedBox(
                                                                                              height: 2.0.w,
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 3.0.h),
                                                                                              child: Text(
                                                                                                "Upload a Book",
                                                                                                style: GoogleFonts.montserrat(color: Color(0xff394C73), fontSize: 12.0.sp, fontWeight: FontWeight.w600),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 2.0.w,
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
                                                                                              child: Text(
                                                                                                "Preview Book",
                                                                                                style: GoogleFonts.montserrat(color: Colors.blueGrey, fontSize: 6.0.sp, fontWeight: FontWeight.w300),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.symmetric(vertical: 1.0.w, horizontal: 3.0.h),
                                                                                              child: Container(
                                                                                                height: 7.0.w,
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    Expanded(flex: 9, child: Container(padding: EdgeInsets.symmetric(horizontal: 1.0.h), child: bookPreViewUrl != null ? Text("Preview Book Added", overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 8.0.sp, fontWeight: FontWeight.w500)) : Text("bhukss/hshsbkoisk.epub", overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 8.0.sp, fontWeight: FontWeight.w500)))),
                                                                                                    Expanded(
                                                                                                        flex: 1,
                                                                                                        child: GestureDetector(
                                                                                                          onTap: () {
                                                                                                            pickPreviewFile();
                                                                                                          },
                                                                                                          child: Container(
                                                                                                            child: Icon(
                                                                                                              FontAwesomeIcons.upload,
                                                                                                              color: ConstantColors.greenColor,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ))
                                                                                                  ],
                                                                                                ),
                                                                                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.grey[350]!)),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 2.0.w,
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
                                                                                              child: Text(
                                                                                                "Full Book",
                                                                                                style: GoogleFonts.montserrat(color: Colors.blueGrey, fontSize: 6.0.sp, fontWeight: FontWeight.w300),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 3.0.h),
                                                                                              child: Container(
                                                                                                height: 7.0.w,
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    Expanded(flex: 9, child: Container(padding: EdgeInsets.symmetric(horizontal: 1.0.h), child: bookFullUrl != null ? Text("Full Book Added", overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 8.0.sp, fontWeight: FontWeight.w500)) : Text("bhukss/hshsbkoisk.epub", overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 8.0.sp, fontWeight: FontWeight.w500)))),
                                                                                                    Expanded(
                                                                                                        flex: 1,
                                                                                                        child: GestureDetector(
                                                                                                          onTap: () {
                                                                                                            pickFullFile();
                                                                                                          },
                                                                                                          child: Container(
                                                                                                            child: Icon(
                                                                                                              FontAwesomeIcons.upload,
                                                                                                              color: ConstantColors.greenColor,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ))
                                                                                                  ],
                                                                                                ),
                                                                                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.grey[350]!)),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 2.0.w,
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
                                                                                              child: Text(
                                                                                                "Cover Image",
                                                                                                style: GoogleFonts.montserrat(color: Colors.blueGrey, fontSize: 6.0.sp, fontWeight: FontWeight.w300),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.symmetric(vertical: 1.0.w, horizontal: 3.0.h),
                                                                                              child: GestureDetector(
                                                                                                onTap: () {
                                                                                                  pickCoverImage();
                                                                                                },
                                                                                                child: Container(
                                                                                                  height: 20.0.w,
                                                                                                  child: Center(
                                                                                                    child: Icon(
                                                                                                      FontAwesomeIcons.solidFolderOpen,
                                                                                                      size: 25.0.sp,
                                                                                                      color: ConstantColors.greenColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.grey[350]!)),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              width: double.infinity,
                                                                                              child: Align(
                                                                                                alignment: Alignment.centerRight,
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsets.only(right: 3.0.h, top: 2.0.w),
                                                                                                  child: ElevatedButton(
                                                                                                      style: ButtonStyle(elevation: MaterialStateProperty.all(10), padding: MaterialStateProperty.all(EdgeInsets.all(2.0.h)), backgroundColor: MaterialStateProperty.all(ConstantColors.blueColor), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.0.h))))),
                                                                                                      onPressed: () async {
                                                                                                        if (collectionNameController.text.isNotEmpty && bookNameController.text.isNotEmpty && bookDiscrController.text.isNotEmpty && bookPriceController.text.isNotEmpty && bookPreViewUrl!.isNotEmpty && bookFullUrl!.isNotEmpty) {
                                                                                                          await FirebaseFirestore.instance.collection(BOOK_COLLECTION).doc(bookId!).set({
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
                                                                                                                  title: Text('Success'),
                                                                                                                  content: SingleChildScrollView(
                                                                                                                    child: ListBody(
                                                                                                                      children: <Widget>[
                                                                                                                        Text('This to inform you that Book has beed uploaded to database!'),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  actions: <Widget>[
                                                                                                                    TextButton(
                                                                                                                      child: Text('ok'),
                                                                                                                      onPressed: () {
                                                                                                                        context.vRouter.to("/home");
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
                                                                                                                      Text('This is to inform you that the fields are empty'),
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
                                                                                                      child: Text(
                                                                                                        "Upload",
                                                                                                        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 8.0.sp, fontWeight: FontWeight.w300),
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
                                                                            });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Next",
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 8.0.sp,
                                                                            fontWeight: FontWeight.w300),
                                                                      )),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2.0.w,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Upload Image",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 6.0.sp,
                                        fontWeight: FontWeight.w300),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.w),
                                child: Text("Supported File Types:",
                                    style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 6.0.sp,
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1.0.w),
                                child: Text("JPG, JPEG, PNG, WEBP",
                                    style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 6.0.sp,
                                    )),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0.h))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.0.w,
                ),
                Container(
                  margin: EdgeInsets.only(top: 2.0.w),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 50.0.h,
                          height: 90.0.w,
                          child: Image.asset(
                            "Images/illustration1.png",
                            fit: BoxFit.contain,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
