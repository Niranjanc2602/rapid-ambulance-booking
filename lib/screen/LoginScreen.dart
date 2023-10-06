
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool user = true;

  void checkAuth()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      user =userCredential.user;
    }on FirebaseAuthException catch(e){
      print(e);
    }
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(hintText: 'email'),
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(hintText: 'password'),
          ),
          BackButton(onPressed: checkAuth,)
        ],
      ),
    );
  }
}
