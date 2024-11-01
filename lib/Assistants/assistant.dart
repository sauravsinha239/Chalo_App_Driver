
import 'dart:developer';

import 'package:drivers/Assistants/request_assistant.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../model/tripHistoryModel.dart';
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
  // print("Response Status is   = $responseDirectionApi");
  // log("Check connection of direction Status is = $responseDirectionApi");
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
  double durationValue= durationValueForFare - directionDetailsInfo.durationValue!;
  double distanceValue= distanceValueForFare- directionDetailsInfo.distanceValue!;

    // Calculate fare components based on duration and distance in minutes and kilometers
    // double timeTravelledFareAmountPerMinute = (directionDetailsInfo.durationValue! / 60) * 3.0; // 2 INR per minute
    // double distanceTravelledFareAmountPerKilometer = (directionDetailsInfo.distanceValue! / 1000) * 10.0;
  double timeTravelledFareAmountPerMinute = (durationValue / 60) * 2.0; // 2 INR per minute
  double distanceTravelledFareAmountPerKilometer = (distanceValue / 1000) * 10.0;



    // Total fare amount in INR
    double totalFareAmount = distanceTravelledFareAmountPerKilometer+timeTravelledFareAmountPerMinute;

    // Calculate fare based on vehicle type
    double resultFareAmount;
    log("Distance Tarvel Amount km = ${distanceTravelledFareAmountPerKilometer}");
    log("Distance Value = ${distanceValue}");
    log("Distance Text = ${directionDetailsInfo.distanceText!}");
    log("Duration Text = ${directionDetailsInfo.durationText}");
    log("DurationValue ${durationValue}");
    log("time travel fare amount = ${timeTravelledFareAmountPerMinute}");


    if (driverVehicleType == "bike") {
      resultFareAmount = (totalFareAmount * 0.8); // Discount for bikes
    } else if (driverVehicleType == "cng") {
      resultFareAmount = (totalFareAmount * 1.5); // Higher fare for CNG
    } else if (driverVehicleType == "car") {
      resultFareAmount = (totalFareAmount * 2); // Higher fare for cars
    } else {
      resultFareAmount = totalFareAmount; // Default case
    }
    // Return the fare amount rounded to two decimal places
    log("result fare amount =${resultFareAmount}");
    return double.parse(resultFareAmount.toStringAsFixed(2));

}

// retrieve the trips keys for online user
//trip key == ride request key
static void readTripKeysForOnlineDriver(context){
  FirebaseDatabase.instance.ref().child("All Ride Requests").orderByChild("driverID").equalTo(firebaseAuth.currentUser!.uid).once().then((snap){
    
    if(snap.snapshot.value !=null){
      Map keysTripsId = snap.snapshot.value as Map;
      //
      //count total number trips and share it with provider
      
      int overAllTripCounter =keysTripsId.length;
      Provider.of<AppInfo>(context, listen: false).updateOverAllTripsCounter(overAllTripCounter);

      //share trips key  with Provider

      List<String> tripKeysList =[];
      keysTripsId.forEach((key, value){
        tripKeysList.add(key);
      });
      Provider.of<AppInfo>(context, listen: false).updateOverAllTripsKeys(tripKeysList);

      //get trips key data -read trip complete information'
      readTripKeyInformation(context);
    }
  });

}
  static void readTripKeyInformation(context){

    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeyList;

    for(String eachKey in tripsAllKeys){
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap){
        var eachTripHistory =TripHistoryModel.formSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended"){
          //Update or add each History to OverAllTrips Histroy data list
          Provider.of<AppInfo>(context, listen: false).updateOverAllHistoryInformation(eachTripHistory);
        }
      }).catchError((e){
        print("Error fetching trip history for key $eachKey: $e");
      });
    }
  }
  //read DriverEarnings
static void readDriverEarnings(context){

  FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").once().then((snap){
    if(snap.snapshot.value !=null) {
      String driverEarnings =snap.snapshot.value.toString();
      log("Driver Earnings Found = $driverEarnings");
      print("Driver Earnings Found = $driverEarnings");

      Provider.of<AppInfo>(context ,listen: false).updateDriverTotalEarnings(driverEarnings);
      log("Driver Earnings Found = $driverEarnings");
    }
    });
      readTripKeysForOnlineDriver(context);
    }

    static void readDriverRatings(context){
      FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("ratings").once().then((snap){
        if(snap.snapshot.value !=null) {
          String driverRatings =snap.snapshot.value.toString();
          Provider.of<AppInfo>(context ,listen: false).updateDriverAverageRatings(driverRatings);
          log("Driver Ratings Found = $driverRatings");
        }
      });

    }


}
 

