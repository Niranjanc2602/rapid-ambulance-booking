
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:main_project/db/DatabaseOp.dart';

class AuthOp{

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> regUser(String name)async{
    await auth.currentUser!.updateDisplayName(name);
  }

  Future<String> getUserId()async{
    return auth.currentUser!.uid.toString();
  }

  Future<String?> getUserName()async{
    return auth.currentUser!.displayName;
  }

  Future<String?> getUserPhone()async{
    return auth.currentUser!.phoneNumber;
  }

  void registerUser(String name,String email,String pwd,int phone)async{
    User? user;
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: pwd);
      user =userCredential.user;
      if(user != null){
        user.updateDisplayName(name);
      }
    }on FirebaseAuthException catch(e){
      return Future.error(e.toString());
    }
  }

  Future<void> registerAmbulance(String name,String aubNo)async{
    await auth.currentUser!.updateDisplayName(name);
    DatabaseOp().addAmb(auth.currentUser!.uid, name, auth.currentUser!.phoneNumber.toString(), aubNo);
  }

  Future<void> registerDoctor(String name,String practice)async{
    await auth.currentUser!.updateDisplayName(name);
    DatabaseOp().addDoctor(auth.currentUser!.uid, name, auth.currentUser!.phoneNumber.toString(), practice);
  }

  void logOut(BuildContext context)async{
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}