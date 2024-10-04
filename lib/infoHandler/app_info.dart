
import 'package:flutter/material.dart';

import '../model/directions.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips =  0;
  List<String> historyTripsKeyList = [];
 // List<TripsHistoryModel> allTripsHistoryInformationList = [];

void updatePickUpLocationAddress(Directions userPickUpAddress){
  userPickUpLocation = userPickUpAddress;
  notifyListeners();

}
void updateDropOffLocationAddress(Directions userDropOffAddress){

  userDropOffLocation = userDropOffAddress;
  notifyListeners();
}
}

