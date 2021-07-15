import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growbymargin_webadmin/Utils/Strigns.dart';
import 'package:uuid/uuid.dart';

class ProductUploadMethod {
  String? bookId = Uuid().v4();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future uploadProduct(
      String bookCollectionName,
      String bookName,
      String bookPrice,
      String bookdescripetion,
      String bookCoverImageUrl) async {
    await FirebaseFirestore.instance
        .collection(BOOK_COLLECTION)
        .doc(bookId!)
        .set({
      "bookCollectionName": bookCollectionName,
      "bookName": bookName,
      "bookDescription": bookdescripetion,
      "bookCoverImageUrl": bookCoverImageUrl,
      "bookPrice": bookPrice,
      "bookId": bookId!,
    });
  }
}
