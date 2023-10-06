import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng source;
  final double lat;
  final LatLng destination;
  const MapScreen({Key? key,required this.source,required this.destination, required this.lat}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(12.971599, 77.594566);
  static const LatLng destinationLocation = LatLng(13.009765, 77.525396);

  List<LatLng> polylineCoordinates = [];

  void getPolyPoint()async{
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates("API Key", PointLatLng(sourceLocation.latitude, sourceLocation.longitude), PointLatLng(destinationLocation.latitude, destinationLocation.longitude));
    print(result.points);
    print(result.status);

    if(result.points.isNotEmpty){
      print(result.points);
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getPolyPoint();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("map"),),
      body: GoogleMap(
          initialCameraPosition: const CameraPosition(
              target: sourceLocation,zoom: 15.0),
        // polylines: {
        //     Polyline(polylineId: const PolylineId("route"),points: polylineCoordinates,color: Colors.green,width: 8),
        // },
        markers: {
             Marker(markerId: MarkerId("Reach"),position: LatLng(widget.lat, 77.02355),),
           Marker(markerId: MarkerId("Ambulance"),position: destinationLocation,),
        },
      ),
      //floatingActionButton: FloatingActionButton(onPressed: getPolyPoint),

    );
  }
}
