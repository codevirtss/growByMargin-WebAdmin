import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growbymargin_webadmin/Utils/Responsive.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

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

  // FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // uploadFileToStorage(File file) {
  //   UploadTask task = _firebaseStorage
  //       .ref()
  //       .child("Offers")
  //       .child(offerId!)
  //       .child("images/${DateTime.now().toString()}")
  //       .putFile(file);
  //   return task;
  // }

  // writeImageUrlToFireStore(imageUrl) {
  //   _firebaseFirestore.collection("Offers").doc(offerId!).set({
  //     "imgUrl": imageUrl,
  //     "OfferId": offerId!,
  //     // "destinationUrl": destination.text
  //   });
  // }

  // saveImageUrlToFirebase(UploadTask task) {
  //   task.snapshotEvents.listen((snapShot) {
  //     if (snapShot.state == TaskState.success) {
  //       snapShot.ref
  //           .getDownloadURL()
  //           .then((imageUrl) => writeImageUrlToFireStore(imageUrl));
  //     }
  //   });
  // }

  // Future selectFileToUpload() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform
  //         .pickFiles(allowMultiple: true, type: FileType.image);

  //     if (result != null) {
  //       selectedFiles.clear();

  //       result.files.forEach((selectedFile) {
  //         File file = File(selectedFile.path!);
  //         selectedFiles.add(file);
  //       });

  //       selectedFiles.forEach((file) {
  //         final UploadTask task = uploadFileToStorage(file);
  //         saveImageUrlToFirebase(task);

  //         setState(() {
  //           uploadedTasks.add(task);
  //         });
  //       });
  //     } else {
  //       print("User has cancelled the selection");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  List<UploadTask> uploadedTasks = [];

  List<File> selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: constantColors.mainColor,
          onPressed: () {
          
            // showDialog(
            //     context: context,
            //     builder: (contex) {
            //       return Container(
            //         height: 10.h,
            //         width: 10.h,
            //         child: Card(
            //           child: Column(
            //             children: [
            //               TextField(
            //                 controller: destination,
            //                 decoration: InputDecoration(
            //                   labelText: "Destination",
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       );
            //     });
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
            actions: <Widget>[
              IconButton(
                icon: Icon(EvaIcons.upload),
                onPressed: () {},
              )
            ]),
        body: SingleChildScrollView(
            child: Responsive(
          mobile: selectedFiles.length == 0
              ? Container(
                  child: Center(child: Image.asset("assets/Images/offer.gif")))
              : Container(),
          tablet: selectedFiles.length == 0
              ? Container(
                  child: Center(child: Image.asset("assets/Images/offer.gif")))
              : Container(),
          desktop: selectedFiles.length == 0
              ? Container(
                  child: Center(child: Image.asset("assets/Images/offer.gif")))
              : Container(),
        )));
  }
}
