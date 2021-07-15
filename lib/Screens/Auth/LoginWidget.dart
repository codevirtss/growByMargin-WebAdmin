import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Home/home.dart';
import 'package:growbymargin_webadmin/Services/FirebaseAuth.dart';
import 'package:growbymargin_webadmin/Utils/Button.dart';
import 'package:growbymargin_webadmin/Utils/Dimensions.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

final ConstantColors constantColors = new ConstantColors();
FirebaseAuthOperations firebaseAuthOperations = FirebaseAuthOperations();

class Login_Moblie extends StatelessWidget {
  final emailController;
  final passwordController;
  const Login_Moblie({Key? key, this.emailController, this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60.h,
          width: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/Images/Admin.png"),
          )),
        ),
        Container(
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              "Admin Login @GrowByMargin.com",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 30),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              suffixText: "@growbymargin.com",
              labelText: "Admin Email address",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2.sp)),
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2.sp)),
            ),
          ),
        ),
        vSizedBox1,
        ButtonWidget(
          constantColors: constantColors,
          title: "Sign In",
          onpress: () {
            firebaseAuthOperations.loginasAdmin(
                context, emailController.text, passwordController.text);
          },
        ),
      ],
    );
  }
}

class Login_Desktop extends StatelessWidget {
  final emailController;
  final passwordController;
  const Login_Desktop({Key? key, this.emailController, this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: _size.width > 1340 ? 3 : 4,
          child: Container(
            height: 90.h,
            width: 50.w,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/Images/Admin.png"),
            )),
          ),
        ),
        Expanded(
          flex: _size.width > 1340 ? 2 : 5,
          child: Container(
            height: 90.h,
            width: 50.w,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Text(
                        "Admin Login @GrowByMargin.com",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 50),
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
                    padding: const EdgeInsets.only(left: 0, right: 50),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Admin Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.sp)),
                      ),
                    ),
                  ),
                  vSizedBox1,
                  ButtonWidget(
                    constantColors: constantColors,
                    title: "Sign In",
                    onpress: () {
                      firebaseAuthOperations.loginasAdmin(context,
                          emailController.text, passwordController.text);
                    },
                  ),
                ]),
          ),
        )
      ],
    );
  }
}

class Login_tab extends StatelessWidget {
  final emailController;
  final passwordController;
  const Login_tab({Key? key, this.emailController, this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40.h,
          width: 100.w,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/Images/Admin.png"),
          )),
        ),
        Container(
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              "Admin Login @GrowByMargin.com",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 30),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Admin Email address",
              suffixText: "@growbymargin.com",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2.sp)),
            ),
          ),
        ),
        vSizedBox1,
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 30),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Admin Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2.sp)),
            ),
          ),
        ),
        vSizedBox1,
        ButtonWidget(
          constantColors: constantColors,
          title: "Sign In",
          onpress: () {
            firebaseAuthOperations.loginasAdmin(
                context, emailController.text, passwordController.text);
          },
        ),
      ],
    );
  }
}
