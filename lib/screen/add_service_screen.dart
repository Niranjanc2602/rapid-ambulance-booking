import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:main_project/db/DatabaseOp.dart';
import 'package:main_project/db/location_getter.dart';
import 'package:main_project/screen/location_screen.dart';
import 'package:main_project/ui/UiTime.dart';
import 'package:nice_buttons/nice_buttons.dart';

class AddServiceScreen extends StatefulWidget {
  final String userId;
  const AddServiceScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

String mapApi = "AIzaSyB-8PB5VFo_fKBrzf7rtazbSXsnwyDxOjQ";
//GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class _AddServiceScreenState extends State<AddServiceScreen> {

  double? _lat;
  double? _long;
  bool loading = true;
  Address? address;
  LatLng? latLng;
  List list = [];
  bool locScreen = false;
  DatabaseOp databaseOp = DatabaseOp();
  LocationGetter location = LocationGetter();
  UiTime ui = UiTime();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLongLat();
  }

  getLongLat()async{
    Future<Position> data = location.determinePosition();
    data.then((value) async {
      _lat = value.latitude;
      _long = value.longitude;
      latLng = LatLng(value.latitude, value.longitude);
      print ("$_lat this i s lat and $_long");
      loading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Requirement"),
      ),
      body: (loading == false)
          ?Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              if(list.contains("Ventilator")== false){
                list.add("Ventilator");
              }else{
                list.remove("Ventilator");
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height/10,
                width: MediaQuery.of(context).size.width,
                decoration:BoxDecoration(
                  color: (list.contains("Ventilator"))?Colors.green:Colors.white,
                  border: Border.all(
                      width: 3.0
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(5.0) //                 <--- border radius here
                  ),
                ),
                  child: const Center(child: Text("Ventilator",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,)))),
            ),
          ),
          InkWell(
            onTap: (){
              if(list.contains("Nurse")== false){
                list.add("Nurse");
              }else{
                list.remove("Nurse");
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: MediaQuery.of(context).size.height/10,
                  width: MediaQuery.of(context).size.width,
                  decoration:BoxDecoration(
                    color: (list.contains("Nurse"))?Colors.green:Colors.white,
                    border: Border.all(
                        width: 3.0
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(5.0) //                 <--- border radius here
                    ),
                  ),
                  child: const Center(child: Text("Nurse",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,)))),
            ),
          ),
          InkWell(
            onTap: (){
              if(list.contains("Attender")== false){
                list.add("Attender");
              }else{
                list.remove("Attender");
              }
              setState(() {});
            },
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: MediaQuery.of(context).size.height/10,
                  width: MediaQuery.of(context).size.width,
                  decoration:BoxDecoration(
                    color: (list.contains("Attender"))?Colors.green:Colors.white,
                    border: Border.all(
                        width: 3.0
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(5.0) //                 <--- border radius here
                    ),
                  ),
                  child: const Center(child: Text("Attender",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,))))
            ),
          ),
          InkWell(
            onTap: (){
              if(list.contains("Doctor")== false){
                list.add("Doctor");
              }else{
                list.remove("Doctor");
              }
              setState(() {});
            },
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: MediaQuery.of(context).size.height/10,
                  width: MediaQuery.of(context).size.width,
                  decoration:BoxDecoration(
                    color: (list.contains("Doctor"))?Colors.green:Colors.white,
                    border: Border.all(
                        width: 3.0
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(5.0) //                 <--- border radius here
                    ),
                  ),
                  child: const Center(child: Text("Doctor",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,)))),
            ),
          ),
          NiceButtons(
              stretch: true,
              startColor: Colors.redAccent,
              endColor: Colors.red,
              gradientOrientation: GradientOrientation.Vertical,
              onTap: (finish){
                databaseOp.addService(_lat!, _long!, list,latLng!);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LocationScreen(service: false)));
              },
              child: const Text("Book now",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
          ),
          // ElevatedButton(onPressed: () {
          //
          //   }, child: const Text("Book now"))
        ],
      )
          :const Center(child: CircularProgressIndicator(),),
    );
  }
}


/*
*
*
*
* (address == null)?const Text("get Nearest hospital"): Text(address!.streetAddress.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(onTap:(){setState(() {locScreen = true;});},child: const Text("get Location"),),
              if(address != null)InkWell(onTap:(){setState(() {address = null;});},child: const Text("clear address"),),
            ],
          ),
*
*
*
* Column(
        children: [
          (latLng != null)?Container(
            height: MediaQuery.of(context).size.height/1.4,
            child: GoogleMap(
              initialCameraPosition:  CameraPosition(target: LatLng(latLng!.latitude,latLng!.longitude),zoom: 15.0),
              onTap: (LatLng ll)async{
                latLng = LatLng(ll.latitude, ll.longitude);
                address = await location.getAddress(ll.latitude, ll.longitude);
                setState(() {});
              },
              markers: {Marker(markerId:const MarkerId("Reach"),position: latLng!,),},
            ),
          ):const CircularProgressIndicator(),
          Expanded(child: (address != null)? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(address!.streetAddress.toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){setState(() {
                    locScreen = false;
                  });}, child: const Text("cancel")),
                  ElevatedButton(onPressed: (){}, child: const Text("Conform")),
                ],
              )
            ],
          ):const Text(""))
        ],
      )
*
*
* */

// InkWell(
//   onTap: ()async{
//     Coordinates co = await locationGetter.getCoordinate("msrit");
//     print("${co.longitude}");
//   },
//   child: const Padding(
//     padding: EdgeInsets.all(8.0),
//     child: Text("Address"),
//   ),
// ),
// ElevatedButton(
//     onPressed: ()async{
//       var p = await PlacesAutocomplete.show(
//           context: context,
//           apiKey: mapApi,
//           mode: Mode.overlay, // Mode.fullscreen
//           //language: "fr",
//           //components: [new Component(Component.country, "fr")]
//           );
//       print(p);
//     },
//     child: const Text("Address")
// ),

/*
* 
* 
* Container(
            height: MediaQuery.of(context).size.height/3,
            child: StreamBuilder<DocumentSnapshot>(
              stream: databaseOp.user.doc("Dy8AmtI2A7lP8zVbu5zA").snapshots(),
                builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
                  if(snapshot.hasError || !snapshot.hasData){
                    return const Text("Wait man");
                  }else{
                    var snap = snapshot.data!;
                    return Text(snap["item"][1]);
                  }
                }),
          ),
* 
* 
* 
* */
