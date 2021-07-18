import 'package:flutter/material.dart';

import 'package:growbymargin_webadmin/Screens/Auth/LoginWidget.dart';

import 'package:growbymargin_webadmin/Utils/Responsive.dart';


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
      body: Responsive(
        mobile: SingleChildScrollView(
          child: Login_Moblie(
            emailController: emailController,
            passwordController: passwordController,
          ),
        ),
        desktop: Login_Desktop(
          emailController: emailController,
          passwordController: passwordController,
        ),
        tablet: Login_tab(emailController: emailController,  passwordController: passwordController,),
      ),
    );
  }
}
