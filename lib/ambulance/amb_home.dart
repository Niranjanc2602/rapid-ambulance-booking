import 'package:flutter/material.dart';
import 'package:main_project/ambulance/amb_lobby.dart';
import 'package:main_project/auth/AuthOp.dart';
import 'package:nice_buttons/nice_buttons.dart';

class AmbHome extends StatefulWidget {
  const AmbHome({Key? key}) : super(key: key);

  @override
  State<AmbHome> createState() => _AmbHomeState();
}

class _AmbHomeState extends State<AmbHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ambulance"),),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/ambhome.jpg",),fit: BoxFit.contain)
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NiceButtons(
                onTap: (finish){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Lobby()));
                },
                stretch: true,
                startColor: Colors.redAccent,
                endColor: Colors.red,
                gradientOrientation: GradientOrientation.Vertical,
                child:const Text("Lobby",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
            ),
            NiceButtons(
                onTap: (finish)async{AuthOp().logOut(context);},
                stretch: true,
                startColor: Colors.white,
                endColor: Colors.white,
                gradientOrientation: GradientOrientation.Vertical,
                child:const Text("LogOut",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),)
            ),
            //ElevatedButton(onPressed: ()=> AuthOp().logOut(context), child: const Text("LogOut"))
          ],
        ),
      ),
    );
  }
}
