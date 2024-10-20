import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers/Assistants/assistant.dart';
import 'package:drivers/global/global.dart';
import 'package:drivers/model/userRideRequestInformaition.dart';
import 'package:drivers/pushNotification/pushNotificationSystem.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/newTripScreen.dart';
import '../widgets/getDriverData.dart';


class NotificationDialogBox extends StatefulWidget{
  
  UserRideRequestInformation? userRideRequestIDetails;

  NotificationDialogBox({super.key, this.userRideRequestIDetails});
  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: darkTheme ? Colors.black : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                String? vehicleType = onlineDriverData.vehicleType;
                print("Vehicle Types fetched ${onlineDriverData.vehicleType}");
                String? imagePath;
                switch (vehicleType) {
                  case "car":
                    imagePath = "images/car.png";
                    break;
                  case "cng":
                    imagePath = "images/cng.png";
                    break;
                  case "bike":
                    imagePath = "images/bike.png";
                    break;
                  default:
                    imagePath="images/pick.png";
                }

                return Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                );
              },
            ),

            SizedBox(height: 10),
            // Title
            Text(
              "New Ride Request",
              style:
              TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: darkTheme ? Colors.yellow : Colors.blue,

              ),
            ),
            SizedBox(height: 14),

            Divider(
              height: 2,
              thickness: 1,
              color: darkTheme ? Colors.yellow : Colors.blue,
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Origin Row
                  Row(
                    children: [
                      Image.asset("images/origin.png", width: 30, height: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.userRideRequestIDetails?.originAddress ??
                              "Unknown Origin",
                          style: TextStyle(
                            fontSize: 16,
                            color: darkTheme ? Colors.yellow : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Destination Row
                  Row(
                    children: [
                      Image.asset(
                        "images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.userRideRequestIDetails?.destinationAddress ??
                              "Unknown Destination",
                          style: TextStyle(
                            fontSize: 16,
                            color: darkTheme ? Colors.yellow : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(
              height: 2,
              thickness: 1,
              color: darkTheme ? Colors.yellow : Colors.blue,
            ),

            // Buttons for Accept/Cancel
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {

                      stopAudio();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(240, 40, 40,10),
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  ElevatedButton(
                    onPressed: () {
                      stopAudio();
                      acceptRideRequest(context);
                      //Navigator.pop(context);

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(10, 200, 20,20),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "ACCEPT",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Method to stop and reset audio player
  void stopAudio() {
    audioPlayer.pause();
    audioPlayer.stop();
    audioPlayer = AssetsAudioPlayer(); // Reset the audio player
  }

//Accept ride request logic
  void acceptRideRequest(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value == "idle") {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(firebaseAuth.currentUser!.uid)
            .child("newRideStatus")
            .set("accepted");
        Assistants.pauseLiveLocationUpdate();

        // Navigate to NewTripScreen (if implemented)
         Navigator.push(
             context, MaterialPageRoute(builder: (c) => NewTripScreen(
           userRideRequestInformation: widget.userRideRequestIDetails,
         )));


      } else {
        Fluttertoast.showToast(msg: "The Ride request does not exist.");
      }
    }).catchError((error) {
      // Handle Firebase or connection errors
      Fluttertoast.showToast(msg: "Error occurred: ${error.toString()}");
    });
  }



}