import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_project/auth/AuthOp.dart';
import 'package:main_project/db/DatabaseOp.dart';
import 'package:main_project/screen/add_service_screen.dart';
import 'package:main_project/screen/location_screen.dart';
import 'package:nice_buttons/nice_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String userId = "none";
  bool? loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  void getUserId() async{
    loading = true;
    userId = await AuthOp().getUserId();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home "),),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/ambhome.jpg",),fit: BoxFit.contain)
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:(loading == false)? StreamBuilder<DocumentSnapshot>(
          stream: DatabaseOp().service.doc(userId).snapshots(),
          builder: ( context,AsyncSnapshot<DocumentSnapshot> snapshot){
            if(!snapshot.hasData){
              return const Text("No thing is there");
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NiceButtons(
                      onTap: (finish){
                        if(snapshot.data!.exists == true){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LocationScreen(service: true)));
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddServiceScreen(userId: userId,)));
                        }
                      },
                      stretch: true,
                      startColor: Colors.redAccent,
                      endColor: Colors.red,
                      gradientOrientation: GradientOrientation.Vertical,
                      child:const Text("Get Ambulance",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                  ),
                  NiceButtons(
                      onTap: (finish)async{AuthOp().logOut(context);},
                      stretch: true,
                      startColor: Colors.white,
                      endColor: Colors.white,
                      gradientOrientation: GradientOrientation.Vertical,
                      child:const Text("LogOut",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),)
                  ),
                  //ElevatedButton(onPressed: ()async{AuthOp().logOut(context);}, child: const Text("Logout"))
                ],
              );
            }
          },
        ):const CircularProgressIndicator(),
      ),
    );
  }
}


/*
*
*
*
*
*
* return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) =>
                        Text(snapshot.data!.docs[index]['uid']),
                  )
*
*
*
*
* */