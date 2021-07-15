import 'package:flutter/material.dart';
import 'package:growbymargin_webadmin/Screens/Auth/Navigation.dart';
import 'package:growbymargin_webadmin/Screens/Product/UploadProduct/uploadProductScreen.dart';
import 'package:growbymargin_webadmin/Services/FirebaseAuth.dart';
import 'package:growbymargin_webadmin/Utils/colors.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

FirebaseAuthOperations firebaseAuthOperations = FirebaseAuthOperations();

class _HomeState extends State<Home> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Growbymargin Admin Web',
          style: TextStyle(color: constantColors.blackColor),
        ),
        backgroundColor: constantColors.mainColor,
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                  title: Text('LogOut as Admin'),
                  onTap: () {
                    firebaseAuthOperations.logOutasAdmin(context);
                    Navigator.pop(context);
                  }),
              Divider(),
              ListTile(
                  title: Text('Upload Your Products!'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadProduct()));
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeMobile extends StatefulWidget {
  const HomeMobile({Key? key}) : super(key: key);

  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
