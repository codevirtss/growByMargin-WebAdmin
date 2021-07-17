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

      Reference reference =
          FirebaseStorage.instance.ref().child('CoverImages').child(bookId!);

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
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 5.h,
                            width: 5.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Images/done.jpeg"),
                                ),
                                borderRadius: BorderRadius.circular(2.sp)),
                          );
                        });
                  });
                }
                {
                  return showDialog(
                      context: context,
                      builder: (conetxt) {
                        return Center(
                          child: Container(
                            child: Text(
                              "The Fileds are empty",
                            ),
                            decoration: BoxDecoration(
                                color: constantColors.mainColor,
                                borderRadius: BorderRadius.circular(2.sp)),
                          ),
                        );
                      });
                }
              },
              icon: Icon(EvaIcons.uploadOutline),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Responsive(
          mobile: Column(
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
          // mobile: UploadMobile(
          //   bookDiscr: bookDiscrController.text,
          //   bookName: bookNameController.text,
          //   bookPrice: bookPriceController.text,
          //   bookPreViewUrl: bookPreViewUrl!,
          //   collectionName: collectionNameController.text,
          //   bookFullUrl: bookFullUrl!,
          //   imageUrl: imageUrl!,
          // ),
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
          // tablet: UploadTab(
          //   bookDiscr: bookDiscrController.text,
          //   bookName: bookNameController.text,
          //   bookPrice: bookPriceController.text,
          //   bookPreViewUrl: bookPreViewUrl!,
          //   collectionName: collectionNameController.text,
          //   bookFullUrl: bookFullUrl!,
          //   imageUrl: imageUrl!,
          // ),
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
                          height: 30.h,
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
// Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         height: 30.h,
//                         width: 30.h,
//                         child: Center(
//                             child: imageUrl == null
//                                 ? Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       IconButton(
//                                         onPressed: () {
//                                           pickCoverImage();
//                                         },
//                                         icon: Icon(
//                                           EvaIcons.imageOutline,
//                                           size: 20.sp,
//                                           color: constantColors.mainColor,
//                                         ),
//                                       ),
//                                       Text(
//                                         "Add cover Image",
//                                         style: GoogleFonts.nunito(
//                                             color: Colors.black,
//                                             fontSize: 10.sp,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ],
//                                   )
//                                 : Image.network(imageUrl!)),
//                         decoration: BoxDecoration(
//                             color: constantColors.greyColor,
//                             borderRadius: BorderRadius.circular(10.sp)),
//                       )),
//                   Column(
//                     children: [
//                       Container(
//                         child: Text(
//                           """Upload coverImage fro
// your product""",
//                           style: GoogleFonts.nunito(
//                               color: Colors.black,
//                               fontSize: 10.sp,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: hBox2, top: vBox2),
//                 child: Text(
//                   "Enter your collection name",
//                   style: GoogleFonts.nunito(
//                       color: Colors.black,
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: TextField(
//                   controller: collectionNameController,
//                   decoration: InputDecoration(
//                       labelText: "Collection name",
//                       labelStyle: GoogleFonts.nunito(
//                           color: Colors.black,
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.normal),
//                       hintText: "HurbalLife",
//                       hintStyle: GoogleFonts.nunito(
//                           color: Colors.grey,
//                           fontSize: 18,
//                           fontWeight: FontWeight.normal)),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: TextField(
//                   controller: bookNameController,
//                   decoration: InputDecoration(
//                       labelText: "Book name",
//                       labelStyle: GoogleFonts.nunito(
//                           color: Colors.black,
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.normal),
//                       hintText: "Herbal remedies for life.",
//                       hintStyle: GoogleFonts.nunito(
//                           color: Colors.grey,
//                           fontSize: 18,
//                           fontWeight: FontWeight.normal)),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(left: 20, right: 40),
//                 child: TextField(
//                   controller: bookPriceController,
//                   decoration: InputDecoration(
//                       labelText: "Book Price",
//                       labelStyle: GoogleFonts.nunito(
//                           color: Colors.black,
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.normal),
//                       hintText: "ex: 100\$ ",
//                       hintStyle: GoogleFonts.nunito(
//                           color: Colors.grey,
//                           fontSize: 18,
//                           fontWeight: FontWeight.normal)),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: TextField(
//                   controller: bookDiscrController,
//                   maxLines: null,
//                   maxLength: null,
//                   decoration: InputDecoration(
//                       labelText: "About the books",
//                       labelStyle: GoogleFonts.nunito(
//                           color: Colors.black,
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.normal),
//                       hintText: "Add discription about this ebook",
//                       hintStyle: GoogleFonts.nunito(
//                           color: Colors.grey,
//                           fontSize: 18,
//                           fontWeight: FontWeight.normal)),
//                 ),
//               ),
//             ],
//           ),

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
