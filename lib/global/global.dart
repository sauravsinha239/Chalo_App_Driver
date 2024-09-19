import 'dart:async';

import 'package:drivers/model/driverData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../model/direction_details_info.dart';
import '../model/user_model.dart';

final FirebaseAuth firebaseAuth =FirebaseAuth.instance;
User? currentuser;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
UserModel? UserModelCurrentInfo;
Position? driverCurrentPosition;
DriverData onlineDriver= DriverData();

String? driverVehicleType="";


