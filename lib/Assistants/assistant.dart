
import 'dart:developer';

import 'package:drivers/Assistants/request_assistant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../model/direction_details_info.dart';
import '../model/directions.dart';
import '../model/user_model.dart';

class Assistants{
static void readCurrentOnlineUserInfo()async{
  currentUser = firebaseAuth.currentUser;

  if (currentUser != null) {

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid);

    try {
      // Fetch the user data from the database
      DatabaseEvent event = await userRef.once();
      DataSnapshot snapshot = event.snapshot;

      // Check if the data exists
      if (snapshot.value != null) {
        // Parse the snapshot into UserModel
        userModelCurrentInfo = UserModel.fromSnapshot(snapshot);
        log("User Info Loaded: ${userModelCurrentInfo!.name}");
      } else {
        log("No user data found.");
      }
    } catch (error) {
      log("Error fetching user data: $error");
    }
  } else {
    log("No user is currently logged in.");
  }

}
static Future<String> searchAddressForGeographicCoordinates(Position position, BuildContext context)async {
  String humanReadableAddress = "";
  String apiUrl = "https://maps.gomaps.pro/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$goMapKey";


  var requestResponse = await RequestAssistant.receiveRequest(apiUrl);


  if(requestResponse != "failed"  ) {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];
      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;
      // ignore: use_build_context_synchronously
      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);

  }


  return humanReadableAddress;

}
static Future <DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async{

  // log("Origin position  is = $originPosition");
  // log("Destination Position is =  $destinationPosition");


  String urlObtainOriginToDestinationDirectionDetails = "https://maps.gomaps.pro/maps/api/directions/json?destination=${destinationPosition.latitude},${destinationPosition.longitude}&origin=${originPosition.latitude},${originPosition.longitude}&key=$goMapKey";
  var responseDirectionApi= await RequestAssistant.receiveRequest(urlObtainOriginToDestinationDirectionDetails);
  print("Response Status is   = $responseDirectionApi");
  log("Check connection of direction Status is = $responseDirectionApi");
  if(responseDirectionApi=="Error Occurred Failed \. No Response"){
    // log("Check connection of direction in if cond  $responseDirectionApi");
   // return null;
  }
  DirectionDetailsInfo directionDetailsInfo =DirectionDetailsInfo();
  
  directionDetailsInfo.encodePoints= responseDirectionApi["routes"][0]["overview_polyline"]["points"];

  directionDetailsInfo.distanceText= responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
  directionDetailsInfo.distanceValue= responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
  directionDetailsInfo.durationText= responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
  directionDetailsInfo.durationValue= responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];
  return directionDetailsInfo;

}

static pauseLiveLocationUpdate(){
  streamSubscriptionPosition!.pause();
  Geofire.removeLocation(firebaseAuth.currentUser!.uid);
}
static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){
  double timeTravelledFareAmountPerMinute =(directionDetailsInfo.durationValue! /60)*0.1;
  double distanceTravelledFareAmountPerKilometer = (directionDetailsInfo.distanceValue! /1000)*0.1;
  //USD
  double totalFareAmount= timeTravelledFareAmountPerMinute + distanceTravelledFareAmountPerKilometer;
  double localCurrencyTotalFare =totalFareAmount*107;
  if(driverVehicleType =="bike"){
    double resultFareAmount = ((localCurrencyTotalFare.truncate())*0.8);
    resultFareAmount;
  }
  else if(driverVehicleType=="cng"){
    double resultFareAmount = ((localCurrencyTotalFare.truncate())*1.5);
    resultFareAmount;
  }
  else if(driverVehicleType=="car"){
    double resultFareAmount = ((localCurrencyTotalFare.truncate())*2);
    resultFareAmount;
  }
  else{
    return localCurrencyTotalFare.truncate().toDouble();
  }
  return localCurrencyTotalFare.truncate().toDouble();
}
}