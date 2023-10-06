import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_project/db/DatabaseOp.dart';
import 'package:main_project/doctor/DoctorHome.dart';
import 'package:main_project/screen/home_screen.dart';
import 'package:main_project/screen/phone_screen.dart';
import 'package:main_project/screen/register_screen.dart';

import '../ambulance/amb_home.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {

  bool? loading;
  String user = "none";
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  Future<FirebaseApp> _initializeFirebase()async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  void check()async{
    loading = true;
    if(auth.currentUser != null) {
      user = await DatabaseOp().checkUser(auth.currentUser!.uid);
    }

    loading = false;
    setState(() {});
    print(user);
  }

  Widget loadScreen(){
    return const Scaffold(
      body: Center( child:  CircularProgressIndicator(),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeFirebase(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(auth.currentUser == null){
              return const PhoneLogin();
            }
            else if (auth.currentUser!.displayName != null){
              if(loading == true){
                return loadScreen();
              }
              if(user == "none" ){
              return const HomeScreen();}
              else if(user == "amb"){return const AmbHome();}else{ return const DoctorHome();}
            }else{ return const RegisterScreen();}
          }else{
            return loadScreen();
          }
        });
  }
}
