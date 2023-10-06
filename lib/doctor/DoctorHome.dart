import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_project/doctor/MessageScreen.dart';
import 'package:main_project/ui/UiTime.dart';
import 'package:nice_buttons/nice_buttons.dart';

import '../auth/AuthOp.dart';
import '../db/DatabaseOp.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {

  DatabaseOp databaseOp = DatabaseOp();
  String? userId;
  bool loading = true;
  UiTime ui = UiTime();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  void getUser()async{
    loading = true;
    userId = await AuthOp().getUserId();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"),),
      body: Column(
        children: [
          (loading == false)?SizedBox(
            height: MediaQuery.of(context).size.height/1.3,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: databaseOp.message.where("docId",isEqualTo: userId!).snapshots(),
                builder: (context,AsyncSnapshot snapshot){
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else{
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (_, index){
                          return InkWell(
                            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(userId: docs[index]['userId'], docId: docs[index]['docId'], doctor: true,name: docs[index]['name'],)));},
                              child: ui.nameContainer(docs[index]));
                        });
                  }
                }),
          ): const CircularProgressIndicator(),
          NiceButtons(
              onTap: (finish)async{AuthOp().logOut(context);},
              stretch: true,
              startColor: Colors.white,
              endColor: Colors.white,
              gradientOrientation: GradientOrientation.Vertical,
              child:const Text("LogOut",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),)
          ),
        ],
      ),
    );
  }
}
