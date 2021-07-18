import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:growbymargin_webadmin/Utils/custom_dialog.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:growbymargin_webadmin/Screens/Auth/LoginWidget.dart';

import 'package:uuid/uuid.dart';

class DesktopView extends StatefulWidget {
  const DesktopView({Key? key}) : super(key: key);

  @override
  _DesktopViewState createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: 100.0.h,
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
                        height: 5.0.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.5.w, vertical: 2.0.h),
                        child: Text(
                          "Post New Book",
                          style: GoogleFonts.montserratAlternates(
                              color: Colors.black,
                              fontSize: 15.0.dp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.0.w, vertical: 4.0.h),
                        decoration: DottedDecoration(
                            shape: Shape.box,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.0.w))),
                        height: 70.0.h,
                        width: 40.0.w,
                        child: Container(
                          margin: EdgeInsets.all(1),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 12.0.h),
                                child: Text("Upload Book Cover Image",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.grey,
                                      fontSize: 6.0.dp,
                                    )),
                              ),
                              SizedBox(
                                height: 7.0.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.0.h),
                                child: Text("Drag And Drop Files Here",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 9.0.dp,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 3.0.h),
                                child: Text("OR",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 9.0.dp,
                                        fontWeight: FontWeight.w300)),
                              ),
                              ElevatedButton.icon(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(3.0.h)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xffFE585A))),
                                  onPressed: () {
                                    showDialog(
                                        //barrierColor: Colors.grey[200]!.withOpacity(0.2),

                                        //TODO: Make it false
                                        //    barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox();
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
                                        fontSize: 6.0.dp,
                                        fontWeight: FontWeight.w300),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0.h),
                                child: Text("Supported File Types:",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 6.0.dp,
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1.0.h),
                                child: Text("JPG, JPEG, PNG, WEBP",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 6.0.dp,
                                    )),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0.w))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Container(
                  margin: EdgeInsets.only(top: 2.0.h),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 50.0.w,
                          height: 90.0.h,
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

//   TextEditingController collectionNameController = TextEditingController();
//   TextEditingController bookNameController = TextEditingController();
//   TextEditingController bookDiscrController = TextEditingController();
//   TextEditingController bookPriceController = TextEditingController();

//   String? imageUrl;
//   String? bookId = Uuid().v4();
//   String? bookPreViewUrl;
//   String? bookFullUrl;

//   void pickCoverImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowCompression: true,
//       allowMultiple: false,
//       allowedExtensions: ['jpg', 'png', 'jpeg'],
//     );
//     if (result != null) {
//       Uint8List? uploadFile = result.files.single.bytes;

//       String? filename = result.files.single.name;

//       Reference reference =
//           FirebaseStorage.instance.ref().child('CoverImages').child(bookId!);

//       final UploadTask uploadTask = reference.putData(uploadFile!);
//       uploadTask.whenComplete(() async {
//         String coverImage = await uploadTask.snapshot.ref.getDownloadURL();
//         setState(() {
//           imageUrl = coverImage;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       height: 30.h,
//                       width: 30.h,
//                       child: Center(
//                           child: imageUrl == null
//                               ? Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         pickCoverImage();
//                                       },
//                                       icon: Icon(
//                                         EvaIcons.imageOutline,
//                                         size: 20.sp,
//                                         color: constantColors.mainColor,
//                                       ),
//                                     ),
//                                     Text(
//                                       "Add cover Image",
//                                       style: GoogleFonts.nunito(
//                                           color: Colors.black,
//                                           fontSize: 10.sp,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                   ],
//                                 )
//                               : Image.network(imageUrl!)),
//                       decoration: BoxDecoration(
//                           color: constantColors.greyColor,
//                           borderRadius: BorderRadius.circular(10.sp)),
//                     )),
//                 Column(
//                   children: [
//                     Container(
//                       child: Text(
//                         """Upload coverImage for
//               your product""",
//                         style: GoogleFonts.nunito(
//                             color: Colors.black,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: hBox2, top: vBox2),
//                   child: Text(
//                     "Enter your collection name",
//                     style: GoogleFonts.nunito(
//                         color: Colors.black,
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 Container(
//                   height: 10.0.h,
//                   width: 50.0.w,
//                   child: TextField(
//                     controller: collectionNameController,
//                     decoration: InputDecoration(
//                         //  labelText: "Collection name",
//                         labelStyle: GoogleFonts.nunito(
//                             color: Colors.black,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.normal),
//                         hintText: "Eg:- Herbal Life",
//                         hintStyle: GoogleFonts.nunito(
//                             color: Colors.grey,
//                             fontSize: 18,
//                             fontWeight: FontWeight.normal)),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: bookNameController,
//                     decoration: InputDecoration(
//                         labelText: "Book name",
//                         labelStyle: GoogleFonts.nunito(
//                             color: Colors.black,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.normal),
//                         hintText: "Herbal remedies for life.",
//                         hintStyle: GoogleFonts.nunito(
//                             color: Colors.grey,
//                             fontSize: 18,
//                             fontWeight: FontWeight.normal)),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.only(left: 20, right: 40),
//                   child: TextField(
//                     controller: bookPriceController,
//                     decoration: InputDecoration(
//                         labelText: "Book Price",
//                         labelStyle: GoogleFonts.nunito(
//                             color: Colors.black,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.normal),
//                         hintText: "ex: 100\$ ",
//                         hintStyle: GoogleFonts.nunito(
//                             color: Colors.grey,
//                             fontSize: 18,
//                             fontWeight: FontWeight.normal)),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   child: TextField(
//                     controller: bookDiscrController,
//                     maxLines: null,
//                     maxLength: null,
//                     decoration: InputDecoration(
//                         labelText: "About the books",
//                         labelStyle: GoogleFonts.nunito(
//                             color: Colors.black,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.normal),
//                         hintText: "Add discription about this ebook",
//                         hintStyle: GoogleFonts.nunito(
//                             color: Colors.grey,
//                             fontSize: 18,
//                             fontWeight: FontWeight.normal)),
//                   ),
//                 ),
//               ],
//             )
//           ],

//         ),
//       ),
//     );
//   }
// }
}
