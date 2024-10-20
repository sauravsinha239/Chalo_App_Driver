import 'dart:developer';

import 'package:drivers/global/global.dart';
import 'package:drivers/model/userRideRequestInformaition.dart';
import 'package:drivers/pushNotification/notificationDialogBox.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem{

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async{
    // if Terminated
    //when then app is closed and open directly from push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage){
      if(remoteMessage!=null){
        readUserRideRequestInformation(remoteMessage.data["rideRequestId"],context);

      }
    });
    //2 foreground
    //when app is open and recive push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage ){
      readUserRideRequestInformation(remoteMessage?.data["rideRequestId"],context);
    });
    //3. Background
    //when app is int the background and open directly from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage){
      readUserRideRequestInformation(remoteMessage?.data["rideRequestId"],context);
    });
  }
  void readUserRideRequestInformation(String userRideRequestId, BuildContext context) {

    final driverRequestRef = FirebaseDatabase.instance.ref().child("All Ride Requests").child(userRideRequestId).child("driverID");

    driverRequestRef.onValue.drain();

    // Attach a listener for ride request data
    driverRequestRef.once().then((event) {
      final driverId = event.snapshot.value;
      print("Driver ID from Firebase: $driverId");

      // Check if the ride request is valid for this driver
      if (driverId == "waiting" || driverId == firebaseAuth.currentUser!.uid) {
        print("Ride request is valid for this driver.");

        // Fetch full ride request details
        FirebaseDatabase.instance.ref().child("All Ride Requests").child(userRideRequestId).once().then((snapData) async {
          if (snapData.snapshot.value != null) {
            print("Ride request found. Processing details.");

            // Process the ride request details
            final rideData = snapData.snapshot.value as Map;
            double ? originLat = double.tryParse(rideData["origin"]["Latitude"].toString());
            double ? originLng = double.tryParse(rideData["origin"]["Longitude"]!.toString()) ;
            String originAddress = rideData["originAddress"]?.toString() ?? 'Unknown Address';
            double ? destinationLat = double.tryParse(rideData["destination"]["Latitude"].toString());

            double  ?destinationLng = double.tryParse(rideData["destination"]["Longitude"].toString() );
            String destinationAddress = rideData["destinationAddress"]?.toString() ?? 'Unknown Address';
            String userName = rideData["userName"]?.toString() ?? 'Unknown User';
            String userPhone = rideData["userPhone"]?.toString() ?? 'Unknown Phone';
            String? rideRequestId = snapData.snapshot.key;
            log("Destination latlng = ${destinationLng} ${destinationLat}");
            log("Origin latlng = $originLng} ${originLat}");


            // Create an instance of UserRideRequestInformation with fetched details
            UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
            userRideRequestDetails.originLatLng = LatLng(originLat!, originLng!);
            userRideRequestDetails.originAddress = originAddress;
            userRideRequestDetails.destinationLatLng = LatLng(destinationLat!, destinationLng!);
            userRideRequestDetails.destinationAddress = destinationAddress;
            userRideRequestDetails.userName = userName;
            userRideRequestDetails.userPhone = userPhone;
            userRideRequestDetails.rideRequestId = rideRequestId;

            // Show the notification dialog box
            await showDialog(
              context: context,
              builder: (BuildContext context) => NotificationDialogBox(
                userRideRequestIDetails: userRideRequestDetails,
              ),
            );
          } else {
            Fluttertoast.showToast(msg: "This Ride Request Id does not exist.");
          }
        });
      } else {
        // If the ride request has been cancelled or assigned to another driver
        Fluttertoast.showToast(msg: "This Ride Request has been Cancelled.");
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    }).catchError((error) {
      // Handle any errors from Firebase
      Fluttertoast.showToast(msg: "Error occurred: ${error.toString()}");
    });
  }


  Future genRateAndGetTokens()async{
    String? registrationToken= await messaging.getToken();
    FirebaseDatabase.instance.ref()
    .child("drivers")
    .child(firebaseAuth.currentUser!.uid)
    .child("token")
    .set(registrationToken);
    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("AllUsers");
  }
  }