import 'dart:async';

import 'package:drivers/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Assistants/assistant.dart';

class Hometab extends StatefulWidget{
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  GoogleMapController ? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  var geoLocation = Geolocator();
  LocationPermission? _locationPermission;
  String statusText = "Now Offline";
  Color buttonColor =Colors.grey;
  bool isDriverActive =false;


  //locate  position
  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;
    LatLng latlngPosition =
    LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: latlngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //ReverseGeoCode
    String humanReadableAddress =
    await Assistants.searchAddressForGeographicCoordinates(
        driverCurrentPosition!, context);

  }


  //permission check
  void CheckIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }
readCurrentDriverInformation()async{
    currentuser =firebaseAuth.currentUser;
     FirebaseDatabase.instance.ref()
        .child("drivers")
    .child(currentuser!.uid)
    .once()
    .then((snap){
      if(snap.snapshot.value!=null){
        onlineDriver.id=(snap.snapshot.value as Map)["id"];
        onlineDriver.name=(snap.snapshot.value as Map)["name"];
        onlineDriver.phone=(snap.snapshot.value as Map)["phone"];
        onlineDriver.email=(snap.snapshot.value as Map)["email"];
        onlineDriver.address=(snap.snapshot.value as Map)["address"];
        onlineDriver.vehicleModel=(snap.snapshot.value as Map)["vehicleDetails"]["vehicleModel"];
        onlineDriver.vehicleNumber=(snap.snapshot.value as Map)["vehicleDetails"]["vehicleNumber"];
        onlineDriver.vehicleColor=(snap.snapshot.value as Map)["vehicleDetails"]["vehicleColor"];
        driverVehicleType=(snap.snapshot.value as Map)["vehicleDetails"]["type"];


      }
    });
}
  @override
  initState()  {
    super.initState();
    CheckIfLocationPermissionAllowed();
    readCurrentDriverInformation();

  }

  @override
  Widget build(BuildContext context) {
    bool darktheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
   return Stack(
     children: [
       GoogleMap(
         padding: EdgeInsets.only(top: 60,),
         mapType: MapType.normal,
         myLocationEnabled: true,
         zoomControlsEnabled: true,
         zoomGesturesEnabled: true,
         compassEnabled: true,
         mapToolbarEnabled: true,
         buildingsEnabled: true,
         initialCameraPosition: _kGooglePlex,
         onMapCreated: (GoogleMapController controller) {
           _controllerGoogleMap.complete(controller);
           newGoogleMapController = controller;
           locateDriverPosition();
         },

       ),
       //Ui for Online offline Driver
       statusText != "Now Online" ?
           Container(
             height: MediaQuery.of(context).size.height,
             width: double.infinity,
             color: Colors.black87,
           ): Container(),
       //Button for online offline Driver
       Positioned(
         top: statusText !="Now Online" ? MediaQuery.of(context).size
           .height*0.45 :40,
           left: 0,
           right: 0,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             ElevatedButton(
                 onPressed: (){
                   if(isDriverActive != true){
                     driverisOnlineNow();
                     updateDriverLocationAtRealTime();
                     setState(() {
                       statusText = "Now Online";
                       isDriverActive=true;
                       buttonColor = Colors.transparent;
                     });
                     Fluttertoast.showToast(msg: "You Are  Online Now!");
                   }
                   else{
                     driverisOfflineNow();
                     setState(() {
                       statusText="Now Offline";
                       isDriverActive=false;
                       buttonColor= Colors.grey;
                     });
                     Fluttertoast.showToast(msg: "You Are  Offline Now!");
                   }

                 },style: ElevatedButton.styleFrom(

               padding: EdgeInsets.symmetric(horizontal: 18),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(26),
               ),
             ),
                 child: statusText != "Now Online"? Text(statusText,
                  style: TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                 ),
                 ) : Icon( Icons.phonelink_ring,
                   color: darktheme ? Colors.yellow: Colors.red,
                   size: 26,
                 ),
             ),
           ],
         ),
       )


     ],
   );
  }
  driverisOnlineNow()async{
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;
    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentuser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentuser!.uid).child("newRideStatus");
    ref.set("idle");

    ref.onValue.listen((event){});
  }
  updateDriverLocationAtRealTime(){
  streamSubscriptionPosition  = Geolocator.getPositionStream().listen((Position position){
    if(isDriverActive== true){
      Geofire.setLocation(currentuser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    }
    LatLng latlng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latlng));
  });
  }
  driverisOfflineNow(){
    Geofire.removeLocation(currentuser!.uid);
    DatabaseReference? ref=FirebaseDatabase.instance.ref().child("drivers").child(currentuser!.uid).child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref =null;
    Future.delayed(Duration(microseconds: 2000),(){
      SystemChannels.platform.invokeMethod("SystemNavigetor.pop");
    });
  }
}