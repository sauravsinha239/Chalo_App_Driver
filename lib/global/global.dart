import 'dart:async';

import 'package:drivers/model/driverInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../model/direction_details_info.dart';
import '../model/user_model.dart';

final FirebaseAuth firebaseAuth =FirebaseAuth.instance;
User? currentUser;
double distanceValueForFare=0.0;
double durationValueForFare=0.0;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
//AssetsAudioPlayer audioPlayer =AssetsAudioPlayer();
UserModel? userModelCurrentInfo;
Position? driverCurrentPosition;
DriverInfo onlineDriverData = DriverInfo();
String? driverVehicleType="";
String titleStarRating="";


