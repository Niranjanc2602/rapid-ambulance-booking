import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:main_project/ambulance/amb_test.dart';
import 'package:main_project/auth/AuthOp.dart';
import 'package:main_project/db/DatabaseOp.dart';
import 'package:main_project/db/location_getter.dart';
import 'package:main_project/db/map_Luanch.dart';
import 'package:main_project/ui/UiTime.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {

  double? _lat;
  double? _long;
  bool? loading;
  Address? address;
  bool updateLoading =false;
  bool addressLoading = false;
  bool callLoading = false;
  String? userId;
  UiTime uiTime = UiTime();
  DatabaseOp databaseOp = DatabaseOp();
  LocationGetter locationGetter = LocationGetter();
  //18-1-23
  int timerCount = 0;
  int index = 0;
  List user = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLatLong();
  }

  getLatLong()async{
    userId = await AuthOp().getUserId();
    loading = true;
    Future<Position> data = locationGetter.determinePosition();
    data.then((value) {
      setState(() {
        _lat = value.latitude;
        _long = value.longitude;
      });
      print("$_lat  this is long $_long");
      loading = false;
      countDownTimer();
    });
    print("exit");
  }

  getLatLongToUser(String id)async{
    if(updateLoading == true){
      return ;
    }
    updateLoading = true;
    Future<Position> data = locationGetter.determinePosition();
    data.then((value) {
        databaseOp.updateLocation(id, value.latitude, value.longitude);
    });
    print("$_lat  this is long $_long");
    updateLoading = false;
  }

  getAddress(double lat,double lng)async{
    if(addressLoading == true){
      return ;
    }
    addressLoading = true;
    address = await locationGetter.getAddress(lat, lng);
    addressLoading = false;
    setState(() {
      print(address!.streetAddress);
    });
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

  countDownTimer() async {
    print("entered");
    user = await databaseOp.getTest();
    for(int y = 0 ; y <= user.length; y++){
      timerCount = 5;
      index = y;
      for (int x = timerCount; x >= 0; x--) {
        await Future.delayed( const Duration(seconds: 1)).then((_) {
          if (mounted) {
            setState(() {
              timerCount = timerCount - 1;
            });
          }
        });
      }
      if(y+1 == user.length ){
        y = -1;
      }
    }
  }

  Widget mapSlide(BuildContext context, data){
    if(data['loc'] == false){
      getLatLongToUser(data['uid']);
    }
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/ambbg.jpg",),fit: BoxFit.cover)
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: databaseOp.service.where("driveId",isEqualTo: data['uid']).get(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return const Text("network error");
            }else{
              if(address == null){
                getAddress(snapshot.data!.docs[0]['uLat'], snapshot.data!.docs[0]['uLong']);
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 150.0,horizontal: 30.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 10.0,color: Colors.white),
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ${snapshot.data!.docs[0]['name']}",style: uiTime.getBold(),),
                          const Divider(thickness: 1.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Phone : ${snapshot.data!.docs[0]['phone'].toString()}",style: uiTime.getBold(),),
                              if(callLoading == false)IconButton(onPressed: ()async{
                                await makeCall(snapshot.data!.docs[0]['phone'].toString());
                              }, icon: const Icon(Icons.call)) else const CircularProgressIndicator(),
                            ],
                          ),                          const Divider(thickness: 1.0),
                          if(addressLoading == false) Text("Address : ${address!.streetNumber.toString()} , ${address!.streetAddress.toString()}",style: uiTime.getBold(),),
                          if(addressLoading == false) Text("  ${address!.city.toString()} - ${address!.postal.toString()} ,\n ${address!.countryName.toString()}"),
                          const Divider(thickness: 1.0),
                          //ElevatedButton(onPressed: (){databaseOp.cancelFromDrive(snapshot.data!.docs[0].id, snapshot.data!.docs[0]["driveId"]);}, child: const Text("cancel")),
                          //ElevatedButton(onPressed: ()async{await MapLaunch.openMap(snapshot.data!.docs[0]['uLat'], snapshot.data!.docs[0]['uLong']);}, child: const Text("map")),
                          NiceButtons(
                              onTap: (finish)async{
                                await MapLaunch.openMap(snapshot.data!.docs[0]['uLat'], snapshot.data!.docs[0]['uLong']);
                              },
                              stretch: true,
                              startColor: Colors.redAccent,
                              endColor: Colors.red,
                              //progress: true,
                              gradientOrientation: GradientOrientation.Vertical,
                              child:const Text("Pick Up Map",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                          ),

                          NiceButtons(
                              onTap: (finish)async{
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AmbTest(lat: snapshot.data!.docs[0]['uLat'],lng: snapshot.data!.docs[0]['uLong'],)));
                                //await MapLaunch.openMap(snapshot.data!.docs[0]['uLat'], snapshot.data!.docs[0]['uLong']);
                              },
                              stretch: true,
                              startColor: Colors.redAccent,
                              endColor: Colors.red,
                              //progress: true,
                              gradientOrientation: GradientOrientation.Vertical,
                              child:const Text("Drop Location Map",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: 10,
                        //child:,
                      )
                  ),
                  NiceButtons(
                    onTap: (finish){databaseOp.cancelFromDrive(snapshot.data!.docs[0].id, snapshot.data!.docs[0]["driveId"]);},
                     startColor: Colors.white,
                     endColor: Colors.white,
                    stretch: true,
                    gradientOrientation: GradientOrientation.Horizontal,
                    child:const Text("Cancel",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget userContainer(BuildContext context,data){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 2.0,color: Colors.red,),
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("time : ${timerCount.toString()}",style: uiTime.getBold(),),

              Text("Name : ${data['name']}",style: uiTime.getBold(),),
              const Divider(),
              Text("Dist : ${locationGetter.distBw(data['uLat'].toString(), data['uLong'].toString(), _lat.toString(), _long.toString())} Km",style: uiTime.getBold(),),
              (data['item'].toString() != "[]") ?Text("Requirement :${data['item']} "):const Text("Requirement : none"),
              NiceButtons(
                  onTap: (finish){databaseOp.updateService(data["uid"], _lat!, _long!);},
                  startColor: Colors.white,
                  endColor: Colors.white,
                  child: const Text(" Accept ",style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.w700),)
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency",style: uiTime.getBoldWhite(),),centerTitle: true,backgroundColor: Colors.transparent),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: (loading == false)?StreamBuilder(
          stream: databaseOp.ambulance.where("uid",isEqualTo: userId).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap){
            if(!snap.hasData){
              return const Text("Network Error");
            }else{
              if(snap.data!.docs[0]['active'] == true){
                return mapSlide(context, snap.data!.docs[0]);
              }else{
                if(user.isEmpty){
                  return const CircularProgressIndicator();
                }else{
                  return userContainer(context, user[index]);
                }
              }
            }
          }
      ):const Center(child: CircularProgressIndicator()),
    );
  }
}


/*
 *
 *
 *
 *
 * return StreamBuilder(
                  stream: databaseOp.service.snapshots(),
                  builder: ( context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return const Text("No thing is there");
                    }else{
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            if(snapshot.data!.docs[index]['driveId'] != "none"){
                              return const Text("");
                            }else{
                              return SingleChildScrollView(child: userContainer(context, snapshot.data!.docs[index]));
                            }
                          }
                        //;}
                      );
                    }
                  },
                );
 *
 * */

/*
*
*
* StreamBuilder(
        stream: databaseOp.service.snapshots(),
        builder: ( context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return const Text("No thing is there");
          }else{
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                return Container(
                  height: 100,
                  //padding: ,
                  child: Column(
                    children: <Widget>[
                      const Text(""),
                      Text("${distBw(snapshot.data!.docs[index]['uLat'].toString(), snapshot.data!.docs[index]['uLong'].toString())} Km" ),
                      ElevatedButton(onPressed: (){databaseOp.updateService(snapshot.data!.docs[index].id, _lat!, _long!);}, child: const Text("Accept"))
                    ],
                  ),
                );
              }
                  //;}
            );
          }
        },
      )
*
* */