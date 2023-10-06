
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:main_project/auth/AuthOp.dart';

class DatabaseOp{

  var service = FirebaseFirestore.instance.collection("service");
  var ambulance = FirebaseFirestore.instance.collection("ambulance");
  var message = FirebaseFirestore.instance.collection("message");
  var doctor = FirebaseFirestore.instance.collection("doctor");
  var hospital = FirebaseFirestore.instance.collection("hospital");
  AuthOp authOp = AuthOp();

  void addService(double lat,double log,List item,LatLng ll)async{
    String uid = await authOp.getUserId();
    String? name = await authOp.getUserName();
    String? phone = await authOp.getUserPhone();
    double la = (ll == null) ? 0: ll.latitude;
    double long = (ll == null) ? 0: ll.longitude;

    await service.doc(uid).set({
      "uLat": lat,
      "uLong": log,
      "driveId":"none",
      "uid":uid,
      "name":name,
      "phone":phone,
      "item":item,
      "dropLa":la,
      "dropLo":long,
    });
  }

  void addAmb(String uid,String name,String phone,String num)async{
    await ambulance.doc(uid).set({
      "uLat": null,
      "uLong": null,
      "uid":uid,
      "active":false,
      "name":name,
      "phone":phone,
      "loc":true,
      "vehicle":num,
    });
  }

  void addDoctor(String uid,String name,String phone,String practice)async{
    await doctor.doc(uid).set({
      "uid":uid,
      "active":false,
      "name":name,
      "phone":phone,
      "pra":practice,
    });
  }

  Future<String> checkUser(String id)async{
    var user = await ambulance.doc(id).get();
    print(user);
    if (user.exists){
      return "amb";
    }else{
      var use = await doctor.doc(id).get();
      if(use.exists){
        return "doctor";
      }else {return "none";}
    }

  }

  void updateService(String uid,double lat,double lng)async{
    String did = await authOp.getUserId();
    print("$did in service update ");
    ambulance.doc(did).update({
      "active" : true,
      "uLat" : lat,
      "uLong" : lng,
      "loc":true,
    });
    service.doc(uid).update({"driveId":did});
  }
  
  void cancelFromDrive(String uid,String did)async{
    service.doc(uid).update({"driveId" : "none"});
    ambulance.doc(did).update({"active": false});
  }

  void cancelFromUser(String uid,String did)async{
    print(did);
    if(did.toString() != "none"){
      await ambulance.doc(did).update({"active":false});
    }
    await service.doc(uid).delete();
  }

  void updateLocation(String driveId,double lat,double lng)async {
    await ambulance.doc(driveId).update({
      "uLat" : lat,
      "uLong" : lng,
      "loc":true,
    });
  }

  void getUpdatedLocation(String driveId)async{
    await ambulance.doc(driveId).update({"loc":false});
  }

  Future<List> getTest()async{
    QuerySnapshot querySnapshot = await service.where("driveId",isEqualTo: "none").get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (int x = 0 ; x < allData.length ; x++ ){
      allData[x]['new'] = 10;
    }
    return allData;
  }

  Future<List> getHospital()async{
    QuerySnapshot querySnapshot = await hospital.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (int x = 0 ; x < allData.length ; x++ ){
      allData[x]['new'] = 10;
    }
    return allData;
  }

  void sendMessage(String text,String dId,String uid,bool doctor)async{
    if(doctor == true){
      message.doc("$uid-$dId").update({"seen":DateTime.now().millisecondsSinceEpoch});
    }else{
      message.doc("$uid-$dId").update({"send":DateTime.now().millisecondsSinceEpoch});
    }
    message.doc("$uid-$dId").collection("message")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "text":text,
      "time":DateTime.now(),
      "uid": (doctor == false)?uid:dId
        });
  }

}