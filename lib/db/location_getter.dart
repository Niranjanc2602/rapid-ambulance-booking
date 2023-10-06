import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

class LocationGetter{

  GeoCode geoCode = GeoCode();

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<Address> getAddress(double lat,double lng)async{
    Address address = await geoCode.reverseGeocoding(latitude: lat, longitude: lng);
    return address;
  }

  Future<Coordinates> getCoordinate(String address)async{
    Coordinates coordinates = await geoCode.forwardGeocoding(address: address);
    return coordinates;
  }

  String distBw(String eLat,String eLong,String oLat,String oLong){

    double ela = double.parse(eLat);
    double elon = double.parse(eLong);
    double ola = double.parse(oLat);
    double olon = double.parse(oLong);
    return (Geolocator.distanceBetween(ola,olon, ela, elon)/1000).toStringAsFixed(2);
  }
}