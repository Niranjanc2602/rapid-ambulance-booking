import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:main_project/auth/AuthOp.dart';
import 'package:main_project/db/DatabaseOp.dart';
import 'package:main_project/db/location_getter.dart';
import 'package:main_project/doctor/MessageScreen.dart';
import 'package:main_project/ui/UiTime.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationScreen extends StatefulWidget {
  final bool service;
  const LocationScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {


  String? address;
  bool loading = true;
  bool callLoading = false;
  String? userId;
  DatabaseOp databaseOp = DatabaseOp();
  UiTime uiTime = UiTime();
  LocationGetter locationGetter = LocationGetter();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLatLong();
  }

  getLatLong()async{
    userId = await AuthOp().getUserId();
    loading = false;
    setState(() {});
  }

  Future<void> makeCall(String number)async{
    callLoading = true;
    setState(() {});
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
    callLoading = false;
  }

  void cancelService(String driverId)async{
     databaseOp.cancelFromUser(userId!, driverId.toString());
     Navigator.pop(context);
  }

  Widget locSide(BuildContext context){
    if(userId == null){
      return const CircularProgressIndicator();
    }else{
      return StreamBuilder<DocumentSnapshot>(
          stream: DatabaseOp().service.doc(userId).snapshots(),
          builder: ( context,AsyncSnapshot<DocumentSnapshot> snapshot){
            if(!snapshot.hasData || snapshot.data == null){
              return const Text("No thing is there");
            } else if (snapshot.hasError){
              return const Text("No thing is there");
            } else {
              Map docu = snapshot.data!.data() as Map;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height/1.3,
                      minHeight: MediaQuery.of(context).size.height/1.5,
                    ),
                    height: MediaQuery.of(context).size.height/1.3,
                    child: (docu['driveId'] == "none")
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text("Getting nearest Ambulance ",style: uiTime.getBold(),),
                        const CircularProgressIndicator(),
                      ],
                    )
                        :driverInfo(context,docu),
                  ),
                  NiceButtons(
                      stretch: true,
                      startColor: Colors.redAccent,
                      endColor: Colors.red,
                      gradientOrientation: GradientOrientation.Vertical,
                      onTap: (finish){cancelService(docu['driveId'].toString());},
                      child: const Text("cancel Ambulance",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                  ),
                ],
              );
            }
          }
      );
    }
  }

  Widget driverInfo(BuildContext context,data){
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseOp().ambulance.doc(data['driveId']).snapshots(),
        builder: ( context,AsyncSnapshot<DocumentSnapshot> snapshot){
          if(!snapshot.hasData){
            return const Text("No thing is there");
          } else{
            Map<String, dynamic> docu = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name : ${docu['name']}",style: uiTime.getBold(),),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Phone : ${docu['phone'].toString()}",style: uiTime.getBold(),),
                    if(callLoading == false)IconButton(onPressed: ()async{
                      await makeCall(docu['phone'].toString());
                    }, icon: const Icon(Icons.call)) else const CircularProgressIndicator(),
                  ],
                ),
                const Divider(),
                Text("Phone : ${docu['vehicle'].toString()}",style: uiTime.getBold(),),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dist : ${locationGetter.distBw(data['uLat'].toString(), data['uLong'].toString(), docu['uLat'].toString(), docu['uLong'].toString())} Km",style: uiTime.getBold(),),
                    Container(child: (docu['loc'] == true)
                        ?ElevatedButton(onPressed: (){ databaseOp.getUpdatedLocation(docu['uid']);}, child: const Text("Refresh"))
                        :const CircularProgressIndicator(),
                    ),
                  ],
                ),
                const Divider(),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    minHeight: MediaQuery.of(context).size.height/3,
                  ),
                  height: MediaQuery.of(context).size.height/2.4,
                  child: GoogleMap(
                    initialCameraPosition:  CameraPosition(target: LatLng(data['uLat'], data['uLong']),zoom: 15.0),
                    markers: {
                       Marker(markerId:const MarkerId("Reach"),position: LatLng(data['uLat'], data['uLong']),),
                       Marker(markerId: const MarkerId("Ambulance"),position: LatLng(docu['uLat'], docu['uLong'])),
                    },
                  ),
                ),
                Expanded(child: Container())
              ],
            );
          }
        }
    );
  }

  //19-1-23
  Widget doctorDetail(){
    return SizedBox(
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Call Doctor"),
              ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("close"))
            ],
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder(
              future: databaseOp.doctor.get(),
                builder:(context,snap){
                  if(!snap.hasData){
                    return const CircularProgressIndicator();
                  }else{
                    List list = snap.data!.docs;
                    return ListView.builder(
                        itemCount: snap.data!.docs.length,
                        itemBuilder: (_,index){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(list[index]["name"],style: uiTime.getBold(),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(list[index]["pra"]),
                                  IconButton(onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MessageScreen(userId: userId!,docId: list[index]["uid"],doctor: false,name: list[index]["name"],)));
                                  }, icon: const Icon(Icons.mail)),
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.phone_android))
                                ],
                              )
                            ],
                          );
                        });
                  }
                } ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("location"),actions: [
        ElevatedButton(onPressed: (){
          showModalBottomSheet(
            context: context,
            builder: (context) {return doctorDetail();},
          );
        }, child: const Text("Call Doctor"))],),
      extendBody: true,
      body: SingleChildScrollView(child: (loading == true)?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text("Getting your location ",style: uiTime.getBold(),),
          const CircularProgressIndicator(),
        ],
      ):locSide(context))
    );
  }
}

