import 'dart:async';

import 'package:drivers/Assistants/blackThemeGoogleMaps.dart';
import 'package:drivers/global/global.dart';
import 'package:drivers/model/driverInfo.dart';
import 'package:drivers/pushNotification/pushNotificationSystem.dart';
import 'package:drivers/splash_screen/splash.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Assistants/assistant.dart';
import '../widgets/getDriverData.dart';


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
    LatLng latLngPosition =
    LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //ReverseGeoCode
     String humanReadableAddress =
    await Assistants.searchAddressForGeographicCoordinates(
        driverCurrentPosition!, context);


  }

  //permission check
  void checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }


GetDriverData gdd =GetDriverData();

@override
  initState()  {
    super.initState();
    checkIfLocationPermissionAllowed();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.genRateAndGetTokens();
    Assistants.readDriverRatings(context);
    Assistants.readDriverEarnings(context);

  }
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
   return Stack(
     children: [
       GoogleMap(
         padding:  EdgeInsets.only(top: 60,),
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
           if(darkTheme==true){
             setState(() {
               blackThemeGoogleMap(newGoogleMapController);
             });
           }
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
                     driverIsOnlineNow();
                     updateDriverLocationAtRealTime();
                     gdd.readCurrentDriverInformation();
                     setState(() {
                       statusText = "Now Online";
                       isDriverActive=true;
                       buttonColor = Colors.transparent;
                     });
                     Fluttertoast.showToast(msg: "You Are  Online Now!");
                   }
                   else{
                     driverOfflineNow();
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
                   color: Colors.blue,
                 ),
                 ) : Icon( Icons.phonelink_ring,
                   color: darkTheme ? Colors.yellow: Colors.red,
                   size: 26,
                 ),
             ),
           ],
         ),
       ),
     ],
   );
  }
// Driver id online now methods
  driverIsOnlineNow()async{
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,

    );

    driverCurrentPosition = pos;
    Geofire.initialize("activeDrivers");

    DatabaseReference refs = FirebaseDatabase.instance
        .ref()
        .child("activeDrivers")
        .child(currentUser!.uid);
    await refs.update({
      "Latitude": pos.latitude,
      "Longitude": pos.longitude
    });

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");
    ref.set("idle");
    ref.onValue.listen((event){});
  }

  updateDriverLocationAtRealTime(){
  streamSubscriptionPosition  = Geolocator.getPositionStream().listen((Position position) async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,

    );
    if(isDriverActive== true){
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("activeDrivers")
        .child(currentUser!.uid);

    await ref.update({
      "Latitude": pos.latitude,
      "Longitude": pos.longitude
    });
    }
    LatLng latLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
  });
  }



  driverOfflineNow(){
    Geofire.removeLocation(currentUser!.uid);
    DatabaseReference? ref=FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
     ref =null;
    Future.delayed(const Duration(microseconds: 8000),(){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> Splash()));


    });

  }
}