import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/ViewUsers/ViewUserDesktop.dart';
import 'package:growbymargin_webadmin/Screens/ViewUsers/ViewUserMobile.dart';
import 'package:growbymargin_webadmin/Screens/ViewUsers/ViewUserTablet.dart';
import 'package:growbymargin_webadmin/Utils/Responsive.dart';

class ViewUser extends StatelessWidget {
  const ViewUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: ViewUserMobile(),
      tablet: ViewUserTablet(),
      desktop: ViewUserDesktop(),
    );
  }
}
