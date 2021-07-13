import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:growbymargin_webadmin/Utils/Dimensions.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 50.h,
            width: 100.w,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/Images/Admin.png"),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 30),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                suffixText: "@growbymargin.com",
                labelText: "Admin Email address",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.sp)),
              ),
            ),
          ),
          vSizedBox1,
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 30),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Admin Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.sp)),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
