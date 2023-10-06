import 'package:flutter/material.dart';
import 'package:main_project/auth/AuthOp.dart';
import 'package:main_project/ui/UiTime.dart';
import 'package:nice_buttons/nice_buttons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController vehicle = TextEditingController();
  String user = "none";
  AuthOp authOp = AuthOp();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register", textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBody: false,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(image: (user == "none")?const AssetImage("assets/amblo.jpg",):const AssetImage("assets/amblog.jpg",),fit: BoxFit.cover)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      labelText: "Enter Name..",
                    ),
                    controller: name,
                  ),
                ),
              ),
              if (user != "none") Padding(
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
                      labelText: "Enter the vehicle number",
                    ),
                    controller: vehicle,
                  ),
                ),
              ),
              NiceButtons(
                progress: true,
                  onTap: (finish)async{
                  if(user == "doctor"){
                    await authOp.registerDoctor(name.text,vehicle.text);
                  }else if(user == "amb"){
                    await authOp.registerAmbulance(name.text, vehicle.text);
                  }else{
                    await authOp.regUser(name.text);
                  }
                    finish();
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  stretch: true,
                  startColor: Colors.redAccent,
                  endColor: Colors.red,
                  gradientOrientation: GradientOrientation.Vertical,
                  child: const Text("Register")
              )
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: (){
          if(user == "none"){
            user = "amb";
          }else if(user == "amb"){
            user = "doctor";
          }else{
            user = "none";
          }
          setState(() {});
          },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width/2.6,

          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(child: (user == "amb")? Text("Ambulance",style: UiTime().getBoldWhite(),):(user == "none")? Text("User",style: UiTime().getBoldWhite(),):Text("Doctor",style: UiTime().getBoldWhite(),)),
        ),),
    );

  }
}


// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController name = TextEditingController();
//   TextEditingController phone = TextEditingController();
//   bool user = true;
//   AuthOp authOp = AuthOp();
//
//   void createUser ()async{
//     if(user == true){
//       authOp.registerUser(name.text, email.text, password.text,int.parse(phone.text));
//     }else{
//        authOp.registerAmbulance(name.text, email.text, password.text,int.parse(phone.text),"");
//     }
//     Navigator.pushNamed(context, '/');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register'),),
//       body: Column(
//         children: [
//           TextField(
//             controller: name,
//             decoration: const InputDecoration(hintText: 'name'),
//           ),
//           TextField(
//             controller: email,
//             decoration: const InputDecoration(hintText: 'email'),
//           ),
//           TextField(
//             controller: phone,
//             decoration: const InputDecoration(hintText: 'phone'),
//           ),
//           TextField(
//             controller: password,
//             decoration: const InputDecoration(hintText: 'password'),
//           ),
//           ElevatedButton(onPressed: ()=>user=true, child: const Text("user")),
//           ElevatedButton(onPressed: ()=>user=false, child: const Text("ambulance")),
//           BackButton(onPressed: createUser,),
//
//           ElevatedButton(onPressed: ()=>Navigator.of(context).pushNamed("/login"), child: const Text("Login"))
//         ],
//       ),
//     );
//   }
// }
