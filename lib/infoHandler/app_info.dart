
import 'package:drivers/model/tripHistoryModel.dart';
import 'package:flutter/material.dart';

import '../model/directions.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips =  0;
  String driverTotalEarnings= "0";
  String driverAverageRatings= "0";

  List<String> historyTripsKeyList = [];
 List<TripHistoryModel> allTripsHistoryInformationList = [];

void updatePickUpLocationAddress(Directions userPickUpAddress){
  userPickUpLocation = userPickUpAddress;
  notifyListeners();

}
void updateDropOffLocationAddress(Directions userDropOffAddress){

  userDropOffLocation = userDropOffAddress;
  notifyListeners();
}
  updateOverAllTripsCounter(int overAllTripsCounter){
    countTotalTrips = overAllTripsCounter;
    notifyListeners();

  }
  updateOverAllTripsKeys(List<String> tripsKeysList){
    historyTripsKeyList =tripsKeysList;
    notifyListeners();
  }

  updateOverAllHistoryInformation(TripHistoryModel eachTripHistory){
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

  updateDriverTotalEarnings(String driverEarnings){
  driverTotalEarnings =driverEarnings;
  notifyListeners();
  }
  updateDriverAverageRatings(String driverRatings){
  driverAverageRatings = driverRatings;
  notifyListeners();
  }


}

