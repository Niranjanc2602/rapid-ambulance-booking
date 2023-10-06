import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:main_project/db/DatabaseOp.dart';
import 'package:main_project/db/location_getter.dart';

class AmbTest extends StatefulWidget {
  final double lat;
  final double lng;
  const AmbTest({Key? key,required this.lat,required this.lng}) : super(key: key);

  @override
  State<AmbTest> createState() => _AmbTestState();
}

class _AmbTestState extends State<AmbTest> {

  Address? address;
  LatLng latLng = LatLng(13.0339331, 77.5633733);
  LocationGetter location = LocationGetter();
  List hospital = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHospital();
  }

  void getHospital()async{
    hospital = await DatabaseOp().getHospital();
    for (int x = 0 ; x < hospital.length ; x++ ){
      hospital[x]['dis'] = location.distBw(widget.lat.toString(), widget.lng.toString(), hospital[x]['lat'].toString(), hospital[x]['long'].toString());
    }
    double min = double.parse(hospital[0]['dis']);
    for(int x = 0 ; x < hospital.length ; x++ ){
      double p = double.parse(hospital[x]['dis']);
      if (min >=  p) {
        min = p;
        latLng = LatLng(hospital[x]['lat'], hospital[x]['long']);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drop to near hospital"),
        //actions: [ElevatedButton(onPressed: countDownTimer, child: const Text("getdata"))],
      ),
      body: (hospital.isEmpty)
          ?const CircularProgressIndicator()
          :Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition:  CameraPosition(target: LatLng(latLng.latitude, latLng.longitude),zoom: 15.0),
              markers: {
                Marker(markerId:const MarkerId("Reach"),position: LatLng(latLng.latitude, latLng.longitude),),
                Marker(markerId: const MarkerId("Ambulance"),position: LatLng(widget.lat, widget.lng)),
              },
            ),
          ),
    );
  }
}

/*
*
*
*
* Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/1.4,
            child: GoogleMap(
              initialCameraPosition:  CameraPosition(target: latLng,zoom: 15.0),
              onTap: (LatLng ll)async{
                latLng = LatLng(ll.latitude, ll.longitude);
                address = await location.getAddress(ll.latitude, ll.longitude);
                setState(() {});
              },
              markers: {Marker(markerId:const MarkerId("Reach"),position: latLng,),},
            ),
          ),
          Expanded(child: (address != null)? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(address!.streetAddress.toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){}, child: const Text("cancel")),
                  ElevatedButton(onPressed: (){}, child: const Text("Conform")),
                ],
              )
            ],
          ):const Text(""))
        ],
      )
*
*
*
* */


// int timerCount = 0;
// int index = 0;
// bool loading = true;
// List user = [];
// DatabaseOp databaseOp = DatabaseOp();
//
// countDownTimer() async {
//   user = await databaseOp.getTest();
//   loading = false;
//   for(int y = 0 ; y <= user.length; y++){
//     timerCount = 5;
//     if (mounted) {
//       setState(() {
//         // Your state change code goes here
//         index = y;
//       });
//     }
//     for (int x = timerCount; x >= 0; x--) {
//       await Future.delayed( const Duration(seconds: 1)).then((_) {
//           timerCount = timerCount - 1;
//       });
//     }
//     if(y+1 == user.length ){
//       y = -1;
//     }
//   }
// }

// getList()async{
//   user = await databaseOp.getTest();
//   loading = false;
//   setState(() {
//
//   });
//   _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
//     print(_currentPage);
//     if (_currentPage < 2) {
//       _currentPage++;
//     } else {
//       _currentPage = 0;
//     }
//
//     _pageController.animateToPage(
//       _currentPage,
//       duration: const Duration(milliseconds: 350),
//       curve: Curves.easeIn,
//     );
//   });
// }