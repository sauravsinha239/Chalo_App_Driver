import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers/model/driverInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../model/direction_details_info.dart';
import '../model/user_model.dart';

final FirebaseAuth firebaseAuth =FirebaseAuth.instance;
User? currentUser;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
AssetsAudioPlayer audioPlayer =AssetsAudioPlayer();
UserModel? userModelCurrentInfo;
Position? driverCurrentPosition;
DriverInfo onlineDriverData = DriverInfo();
String? driverVehicleType="";


