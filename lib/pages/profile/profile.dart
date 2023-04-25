import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/models/uc_model_provider.dart';
import 'package:vhrs_flutter_project/models/uj_model_provider.dart';
import 'package:vhrs_flutter_project/pages/home/home.dart';
import 'package:vhrs_flutter_project/pages/profile/localwidgets/uc_Profile.dart';
import 'package:vhrs_flutter_project/pages/profile/localwidgets/uj_Profile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String typeUser = "";
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<Null> checkRole() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        typeUser = preferences.getString("typeUser")!;
      });
    } catch (e) {}
  }

  Future<Null> signOutProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    if (typeUser == "UserJoin") {
      UjProfile profile = UjProfile();
      profile.ujEmail = "";
      profile.ujName = "";
      profile.ujPhone = "";
      profile.ujIdstd = "";
      profile.ujImg = "";
      profile.ujFaculty = "";
      profile.ujMajor = "";
      context.read<UjModelProvider>().ujProfile = profile;
    } else {
      UcProfile profile = UcProfile();
      profile.ucEmail = "";
      profile.ucName = "";
      profile.ucPhone = "";
      profile.ucImg = "";
      profile.ucStatus = "";
      profile.ucJob = "";
      profile.ucImgconfirmjob = "";
      context.read<UcModelProvider>().ucProfile = profile;
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).secondaryHeaderColor,
          // centerTitle: true,
          title: Text(
            "ข้อมูลผู้ใช้",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                iconSize: 30.sp,
                color: Colors.red,
                icon: Icon(Icons.exit_to_app),
                onPressed: () => signOutProcess())
          ],
        ),
        body: typeUser == 'UserJoin' ? ProfileFormUJ() : ProfileFormUC());
  }
}
