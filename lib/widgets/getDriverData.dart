import 'package:firebase_database/firebase_database.dart';

import '../global/global.dart';
import '../model/driverInfo.dart';

class GetDriverData{

  Future<void> readCurrentDriverInformation()async{
    currentUser =firebaseAuth.currentUser;

    FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).once()
        .then((snap){
      if(snap.snapshot.value!=null){

        onlineDriverData.id=(snap.snapshot.value as Map)["id"];
        onlineDriverData.name=(snap.snapshot.value as Map)["name"];
        onlineDriverData.phone=(snap.snapshot.value as Map)["phone"];
        onlineDriverData.email=(snap.snapshot.value as Map)["email"];
        onlineDriverData.address=(snap.snapshot.value as Map)["address"];
        onlineDriverData.ratings=(snap.snapshot.value as Map)["ratings"];
        onlineDriverData.vehicleModel=(snap.snapshot.value as Map)["vehicleDetails"]["vehicleModel"];
        onlineDriverData.vehicleNumber=(snap.snapshot.value as Map)["vehicleDetails"]["vehicleNumber"];
        onlineDriverData.vehicleColor=(snap.snapshot.value as Map)["vehicleDetails"]["vehicleColor"];
        onlineDriverData.vehicleType=(snap.snapshot.value as Map)["vehicleDetails"]["vehicleType"];
        driverVehicleType=(snap.snapshot.value as Map)["vehicleDetails"]["vehicleType"];
      }

    });
  }
}