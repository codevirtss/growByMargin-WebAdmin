import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ViewUserDesktop extends StatefulWidget {
  const ViewUserDesktop({Key? key}) : super(key: key);

  @override
  _ViewUserDesktopState createState() => _ViewUserDesktopState();
}

class _ViewUserDesktopState extends State<ViewUserDesktop> {
  var allUsers;
  Future getAllUser() async {
    await FirebaseFirestore.instance.collection("Users").get().then((value) {
      allUsers = value.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Card(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Users List ",
                          style: GoogleFonts.nunito(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                  Divider(),
                  FutureBuilder(
                      future: getAllUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                              itemCount: allUsers.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"),
                                  ),
                                  title: Text(
                                    "${allUsers[index]["name"]}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${allUsers[index]["email"]}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Container(
                            child: Center(
                              child: Image.asset("assets/Images/home.gif"),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
