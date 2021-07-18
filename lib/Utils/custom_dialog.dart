// import 'dart:ui';

// import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';

// import 'package:growbymargin_webadmin/Utils/colors.dart';
// import 'package:growbymargin_webadmin/Utils/custom_dialog2.dart';
// import 'package:sizer/sizer.dart';

// class CustomDialogBox extends StatefulWidget {
//   final TextEditingController collectionController;
//   final TextEditingController nameController;
//   final TextEditingController priceController;
//   final TextEditingController descriptionController;

//   const CustomDialogBox(
//       {Key? key,
//       this.collectionController,
//       this.nameController,
//       this.priceController,
//       this.descriptionController})
//       : super(key: key);
//   @override
//   _CustomDialogBoxState createState() => _CustomDialogBoxState();
// }

// class _CustomDialogBoxState extends State<CustomDialogBox> {
//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//       child: Dialog(
//           backgroundColor: Colors.white,
//           elevation: 10,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(2.0.w))),
//           child: Container(
//             height: 80.0.w,
//             width: 40.0.h,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 2.0.w,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: 2.0.w, horizontal: 3.0.h),
//                     child: Text(
//                       "Create a Book",
//                       style: GoogleFonts.nunito(
//                           color: Color(0xff394C73),
//                           fontSize: 12.0.sp,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 2.0.w,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
//                     child: Text(
//                       "Book Collection Name",
//                       style: GoogleFonts.nunito(
//                           color: Colors.blueGrey,
//                           fontSize: 6.0.sp,
//                           fontWeight: FontWeight.w300),
//                     ),
//                   ),
//                   Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 1.0.w, horizontal: 3.0.h),
//                       child: TextField(
//                         style: GoogleFonts.nunito(
//                             color: Colors.black,
//                             fontSize: 8.0.sp,
//                             fontWeight: FontWeight.w300),
//                         decoration: InputDecoration(
//                           alignLabelWithHint: false,
//                           floatingLabelBehavior: FloatingLabelBehavior.never,
//                           contentPadding: EdgeInsets.all(2.0.h),
//                           labelText: "Click to Enter Book Title",
//                           labelStyle: GoogleFonts.nunito(
//                               color: Colors.grey,
//                               fontSize: 8.0.sp,
//                               fontWeight: FontWeight.w300),
//                           hintText: "Eg:- Herbal Remedies",
//                           hintStyle: GoogleFonts.nunito(
//                               color: Colors.grey,
//                               fontSize: 8.0.sp,
//                               fontWeight: FontWeight.w300),
//                           border: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Colors.grey[350]!, width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color(0xff394C73), width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                           disabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color(0xff394C73), width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                         ),
//                       )),
//                   SizedBox(
//                     height: 4.0.w,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
//                     child: Text(
//                       "Book Title",
//                       style: GoogleFonts.nunito(
//                           color: Colors.blueGrey,
//                           fontSize: 6.0.sp,
//                           fontWeight: FontWeight.w300),
//                     ),
//                   ),
//                   Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 1.0.w, horizontal: 3.0.h),
//                       child: TextField(
//                         style: GoogleFonts.nunito(
//                             color: Colors.black,
//                             fontSize: 8.0.sp,
//                             fontWeight: FontWeight.w300),
//                         decoration: InputDecoration(
//                           alignLabelWithHint: false,
//                           floatingLabelBehavior: FloatingLabelBehavior.never,
//                           contentPadding: EdgeInsets.all(2.0.h),
//                           labelText: "Click to Enter Book Title",
//                           labelStyle: GoogleFonts.nunito(
//                               color: Colors.grey,
//                               fontSize: 8.0.sp,
//                               fontWeight: FontWeight.w300),
//                           hintText: "Eg:- Herbal Remedies",
//                           hintStyle: GoogleFonts.nunito(
//                               color: Colors.grey,
//                               fontSize: 8.0.sp,
//                               fontWeight: FontWeight.w300),
//                           border: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Colors.grey[350]!, width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color(0xff394C73), width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                           disabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color(0xff394C73), width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                         ),
//                       )),
//                   SizedBox(
//                     height: 4.0.w,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
//                     child: Text(
//                       "Book Price",
//                       style: GoogleFonts.nunito(
//                           color: Colors.blueGrey,
//                           fontSize: 6.0.sp,
//                           fontWeight: FontWeight.w300),
//                     ),
//                   ),
//                   Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 1.0.w, horizontal: 3.0.h),
//                       child: TextField(
//                         style: GoogleFonts.nunito(
//                             color: Colors.black,
//                             fontSize: 8.0.sp,
//                             fontWeight: FontWeight.w300),
//                         decoration: InputDecoration(
//                           suffixText: "INR",
//                           suffixStyle: GoogleFonts.nunito(
//                               color: Colors.grey,
//                               fontSize: 8.0.sp,
//                               fontWeight: FontWeight.w300),
//                           alignLabelWithHint: false,
//                           floatingLabelBehavior: FloatingLabelBehavior.never,
//                           contentPadding: EdgeInsets.all(2.0.h),
//                           labelText: "Click to Enter Book Price",
//                           labelStyle: GoogleFonts.nunito(
//                               color: Colors.grey,
//                               fontSize: 8.0.sp,
//                               fontWeight: FontWeight.w300),
//                           hintText: "Eg:- 100",
//                           hintStyle: GoogleFonts.nunito(
//                               color: Colors.grey,
//                               fontSize: 8.0.sp,
//                               fontWeight: FontWeight.w300),
//                           border: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Colors.grey[350]!, width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color(0xff394C73), width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                           disabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: Color(0xff394C73), width: 1),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                         ),
//                       )),
//                   SizedBox(
//                     height: 4.0.h,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 0.5.w, left: 3.0.h),
//                     child: Text(
//                       "Book Description",
//                       style: GoogleFonts.nunito(
//                           color: Colors.blueGrey,
//                           fontSize: 6.0.sp,
//                           fontWeight: FontWeight.w300),
//                     ),
//                   ),
//                   Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 1.0.w, horizontal: 3.0.h),
//                       child: Expanded(
//                         child: TextField(
//                           style: GoogleFonts.nunito(
//                               color: Colors.black,
//                               fontSize: 8.0.sp,
//                               fontWeight: FontWeight.w300),
//                           maxLines: 100,
//                           minLines: 1,
//                           decoration: InputDecoration(
//                             isDense: true,
//                             isCollapsed: true,
//                             alignLabelWithHint: false,
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 2.0.w, vertical: 2.0.w),
//                             labelText: "Click to Enter Book Description",
//                             labelStyle: GoogleFonts.nunito(
//                                 color: Colors.grey,
//                                 fontSize: 8.0.sp,
//                                 fontWeight: FontWeight.w300),
//                             hintText:
//                                 "Eg:- This book is specially designed for herbal remedies that can be followed at home",
//                             hintStyle: GoogleFonts.nunito(
//                                 color: Colors.grey,
//                                 fontSize: 8.0.sp,
//                                 fontWeight: FontWeight.w300),
//                             border: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.grey[350]!, width: 1),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10))),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Color(0xff394C73), width: 1),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10))),
//                             disabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Color(0xff394C73), width: 1),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10))),
//                           ),
//                         ),
//                       )),
//                   SizedBox(
//                     height: 4.0.h,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: Padding(
//                         padding: EdgeInsets.only(right: 3.0.h, top: 2.0.w),
//                         child: ElevatedButton(
//                             style: ButtonStyle(
//                                 padding: MaterialStateProperty.all(
//                                     EdgeInsets.all(2.0.h)),
//                                 backgroundColor: MaterialStateProperty.all(
//                                     ConstantColors.greenColor),
//                                 shape: MaterialStateProperty.all(
//                                     RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(1.0.w))))),
//                             onPressed: () {
//                               // context.vRouter.pop();
//                               showDialog(
//                                   //barrierColor: Colors.grey[200]!.withOpacity(0.2),

//                                   //    barrierDismissible: false,
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return CustomDialog();
//                                   });
//                             },
//                             child: Text(
//                               "Next",
//                               style: GoogleFonts.nunito(
//                                   color: Colors.white,
//                                   fontSize: 8.0.sp,
//                                   fontWeight: FontWeight.w300),
//                             )),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 2.0.w,
//                   )
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }
