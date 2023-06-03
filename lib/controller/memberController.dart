import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:skripsiii/model/memberModel.dart';


class memberController extends GetxController{
  late Member _member;
  final Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<void> enableService()async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  Future<void> grantPermission() async{
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }else if(_permissionGranted == PermissionStatus.deniedForever){
      debugPrint('permission is denied forever');
    }
  }

  Future<void> getLocation()async{
    _locationData = await location.getLocation();
  }
}