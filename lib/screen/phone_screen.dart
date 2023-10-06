import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/screen/register_screen.dart';
import 'package:nice_buttons/nice_buttons.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {

  String? phoneNumber, verificationId;
  String? otp, authStatus = "";

  Future<void> verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (AuthCredential authCredential) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const RegisterScreen()), (route) => false);
        print("Your account is successfully verified");
      },
      verificationFailed: (FirebaseAuthException authException) {
        print("Authentication failed");
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        print("TIMEOUT");
      },
      codeSent: (String verId, int? forceResendingToken) {
        verificationId = verId;
        print("OTP has been successfully send");

          otpDialogBox(context).then((value) {});
      },
    );
  }

  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: const Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            actions: <Widget>[
              NiceButtons(
                  onTap: (finish)async{
                    if (await signIn(otp!) == true){
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const RegisterScreen()), (route) => false);
                    }else{
                      Navigator.of(context).pop();
                    }
                    finish();
                  },
                  progress: true,
                  stretch: true,
                  startColor: Colors.redAccent,
                  endColor: Colors.red,
                  gradientOrientation: GradientOrientation.Vertical,
                  child:const Text("Submit",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
              ),
              // ElevatedButton(
              //   onPressed: () async{
              //
              //
              //   },
              //   child: const Text(
              //     'Submit',
              //   ),
              // ),
            ],
          );
        });
  }

  Future<bool> signIn(String otp) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otp));
    User? user = userCredential.user;
    if(user != null){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/death.jpg",),fit: BoxFit.fill)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10,2,10,2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white70,
                    border: Border.all(color: Colors.red)
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Enter Phone Number..",
                  ),
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
              ),
            ),
            NiceButtons(
                onTap: (finish){
                  verifyPhoneNumber();
                  finish();
                },
                progress: true,
                stretch: true,
                startColor: Colors.redAccent,
                endColor: Colors.red,
                gradientOrientation: GradientOrientation.Vertical,
                child:const Text("Login",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
            ),
          ],
        ),
      ),
    );
  }
}
