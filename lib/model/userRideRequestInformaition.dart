import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation{
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String? originAddress;
  String? destinationAddress;
  String? rideRequestId;
  String? userName;
  String? userPhone;
  UserRideRequestInformation({
    this.destinationLatLng,
    this.userName,
    this.originAddress,
    this.destinationAddress,
    this.originLatLng,
    this.rideRequestId,
    this.userPhone,
});
}