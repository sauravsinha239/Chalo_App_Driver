import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:drivers/Assistants/assistant.dart';
import 'package:drivers/global/global.dart';
import 'package:drivers/model/userRideRequestInformaition.dart';
import 'package:drivers/splash_screen/splash.dart';
import 'package:drivers/widgets/fareAmountCollectionDialog.dart';
import 'package:drivers/widgets/progressDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Assistants/blackThemeGoogleMaps.dart';

class NewTripScreen extends StatefulWidget{
  UserRideRequestInformation? userRideRequestInformation;

   NewTripScreen({super.key, this.userRideRequestInformation});
  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  GoogleMapController ? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String? buttonTitle ="Arrived";
  Color? buttonColor = Colors.green;

  Set<Marker> setOfMarker = <Marker>{};
  Set<Circle> setOfCircle =<Circle>{};
  Set<Polyline>setOfPolyline =<Polyline>{};
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints =PolylinePoints();

  double mapPadding=0;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator =Geolocator();
  Position? onlineDriverCurrentPosition;
  String rideRequestStatus ="accepted";
  String durationFromOriginToDestination ="";
  bool isRequestDirectionDetails =false;
  //Step 1: When Driver Accepts the userRide request
  //originLatlng= driverCurrentLocation
  //destinationLatLng  =USer pickup location
  //step2: When driver pickup the user in his car
  //originLatLng = user current Location which will be also the current loaction of the driver at the time
  //destinationLatLng = user's  drop-off location

  Future<void>  drawPolyLineFromOriginToDestination(LatLng originLatLng, LatLng destinationLatLng, bool darkTheme)async{

    showDialog(
        context: context,
        builder: (BuildContext context)=> ProgressDialog(message: "Please Wait...."),
    );
    var directionOnDetailsInfo = await Assistants.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);
    Navigator.pop(context);


    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePositionResultList= pPoints.decodePolyline(directionOnDetailsInfo.encodePoints!);

    //polyLinePositionCoordinates.clear();

    // if(decodePolyLinePositionResultList.isNotEmpty){
    //   for (var pointLatLng in decodePolyLinePositionResultList) {
    //     polyLinePositionCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
    //   }
    // }
    if(decodePolyLinePositionResultList.isNotEmpty){
      decodePolyLinePositionResultList.forEach((PointLatLng pointLatLng){
        polyLinePositionCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    setOfPolyline.clear();

    setState(() {
      Polyline polyline =Polyline(
        polylineId: const PolylineId("PolyLineId"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        geodesic: true,
        width: 5,
        color: darkTheme ? Colors.red: Colors.blue,
      );
      setOfPolyline.add(polyline);
    });
    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude){
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);

    }
    else if(originLatLng.longitude > destinationLatLng.longitude){
      boundsLatLng =LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    }
    else if(originLatLng.latitude> destinationLatLng.latitude){
      boundsLatLng =LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );

    }
    else{
      boundsLatLng= LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    newTripGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
    Marker originMarker =Marker(
        markerId: const MarkerId("originId"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    Marker destinationMarker =Marker(
      markerId: const MarkerId("destinationId"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      setOfMarker.add(originMarker);
      setOfMarker.add(destinationMarker);
    });
    Circle originCircle =Circle(
        circleId: const CircleId("originId"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,

    );
    Circle destinationCircle =Circle(
      circleId: const CircleId("destinationId"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,

    );
    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });

  }


  @override
  void initState() {
    super.initState();
    saveAssignedDriverDetailsToUserRideRequest();

  }
  getDriverLocationAtRealTime(){
    LatLng oldLatLng = LatLng(0, 0);
    streamSubscriptionDriverLivePosition =Geolocator.getPositionStream().listen((Position position){
      driverCurrentPosition =position;
      onlineDriverCurrentPosition =position;
      LatLng latLngLiveDriverPosition =LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);
      Marker animatingMarker =Marker(
          markerId: const MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: "This is your Position"),
      );
      setState(() {
        CameraPosition cameraPosition = CameraPosition(target: latLngLiveDriverPosition,zoom: 18);
        newTripGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarker.removeWhere((element)=> element.markerId.value == "AnimatedMarker");
        setOfMarker.add(animatingMarker);
      });
      oldLatLng =latLngLiveDriverPosition;

updateDurationTimeAtRealTime();

//Updating driver location at realtime in database
    Map driverLatLngDataMap ={
      "Latitude": onlineDriverCurrentPosition!.latitude.toString(),
      "Longitude": onlineDriverCurrentPosition!.longitude.toString(),
    };
    FirebaseDatabase.instance.ref().child("All Ride Requests").child((widget.userRideRequestInformation!.rideRequestId!)).child("driverLocation").set(driverLatLngDataMap);

    });
  }
  updateDurationTimeAtRealTime() async{
    if(isRequestDirectionDetails == false){
      isRequestDirectionDetails = true;
      if(onlineDriverCurrentPosition == null){
        return;
      }
      var originLatLng =LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);
      var destinationLatLng;

      if(rideRequestStatus == "accepted"){
         destinationLatLng= widget.userRideRequestInformation!.originLatLng; //user pickup location

      }
      else{
        destinationLatLng = widget.userRideRequestInformation!.destinationLatLng;

      }
      var directionInformation =await Assistants.obtainOriginToDestinationDirectionDetails(originLatLng,destinationLatLng!);

      if(directionInformation !=null){
        setState(() {
          durationFromOriginToDestination =directionInformation.durationText!;
          durationValueForFare=directionInformation.durationValue!.toDouble();
          distanceValueForFare= directionInformation.distanceValue!.toDouble();

        });
      }
      isRequestDirectionDetails=false;
    }

  }
  Future<Uint8List> getBytesFromAsset(String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);  // Load the image from assets
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  createDriverIconMarker() async {

    if(iconAnimatedMarker == null){
      final Uint8List markerIcon = await getBytesFromAsset('images/car.png', 70,70);
      iconAnimatedMarker = BitmapDescriptor.bytes(markerIcon);
    }
  }
  saveAssignedDriverDetailsToUserRideRequest(){
    DatabaseReference databaseReference =FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestInformation!.rideRequestId!);

    Map diverLocationDataMap ={
      "Latitude": driverCurrentPosition?.latitude.toString() ?? "Unknown",
      "Longitude": driverCurrentPosition?.longitude.toString() ?? "Unknown",
    };

    if(databaseReference.child("driverID") !=  "waiting"){
      databaseReference.child("driverLocation").set(diverLocationDataMap);
      databaseReference.child("status").set("accepted");
      databaseReference.child("driverID").set(onlineDriverData.id);
      databaseReference.child("driverName").set(onlineDriverData.name);
      databaseReference.child("driverPhone").set(onlineDriverData.phone);
      databaseReference.child("ratings").set(onlineDriverData.ratings);
      databaseReference.child("VehicleDetails").set("${onlineDriverData.vehicleModel} ${onlineDriverData.vehicleNumber} (${onlineDriverData.vehicleColor} )");
      saveRideRequestIdToDriverHistory();
    }
    else{
      Fluttertoast.showToast(msg: "This ride is already accepted by another driver. \n Reloading the App ");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>const Splash()));
    }
  }

  saveRideRequestIdToDriverHistory(){
    DatabaseReference tripHistoryRef =FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("tripsHistory");

    tripHistoryRef.child(widget.userRideRequestInformation!.rideRequestId!).set(true);
  }
  endTripNow() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(BuildContext context)=> ProgressDialog(message: "Please Wait....",),
    );
    //get the  TripDirectionDetails =distance travelled
    var currentDriverPositionLatLng = LatLng(onlineDriverCurrentPosition!.latitude,onlineDriverCurrentPosition!.longitude );
    var tripDirectionDetails = await Assistants.obtainOriginToDestinationDirectionDetails(currentDriverPositionLatLng, widget.userRideRequestInformation!.originLatLng!);

    //fare amount

    double totalFareAmount =Assistants.calculateFareAmountFromOriginToDestination(tripDirectionDetails);

    FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestInformation!.rideRequestId!).child("fareAmount").set(totalFareAmount.toString());

    FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestInformation!.rideRequestId!).child("status").set("ended");
    Navigator.pop(context);
    //display fare amount dialog box
    showDialog(
        context: context,
        builder: (BuildContext context)=> FareAmountCollectionDialog(
          totalFareAmount: totalFareAmount,
        )
    );
    //save fare amount to driver total earning
    saveFareAmountToDriverEarnings(totalFareAmount);
    
  }
  saveFareAmountToDriverEarnings(double totalFareAmount){
    FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").once().then((snap){

      if(snap.snapshot.value != null){
        double oldEarnings =double.parse(snap.snapshot.value.toString());
        double driverTotalEarnings =totalFareAmount + oldEarnings;

        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").set(driverTotalEarnings.toString());
      }
      else{
        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("earnings").set(totalFareAmount.toString());
      }
    });
  }

  @override


  Widget build(BuildContext context) {
    bool darkTheme=MediaQuery.of(context).platformBrightness== Brightness.dark;
    createDriverIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding:  const EdgeInsets.only(top: 60,),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            buildingsEnabled: true,
            markers: setOfMarker,
            circles: setOfCircle,
            polylines: setOfPolyline,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;
              if(darkTheme==true){
                setState(() {
                  blackThemeGoogleMap(newTripGoogleMapController);
                });
              }
              setState(() {
                mapPadding=350;
              });
              var driverCurrentLatLng =LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

              var userPickUpLatLng =widget.userRideRequestInformation!.originLatLng;
              drawPolyLineFromOriginToDestination(driverCurrentLatLng, userPickUpLatLng!,darkTheme);
              getDriverLocationAtRealTime();
            },
          ),
          //UI
          Positioned(
            bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(decoration: BoxDecoration(
                  color: darkTheme ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 18,
                      spreadRadius: 0.5,
                      offset: Offset(0.6,0.6),
                    ),
                  ]
                ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                      Text(durationFromOriginToDestination,
                        style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold,
                        color: darkTheme ? Colors.green: Colors.blue ),
                      ),
                        const SizedBox(height: 10,),


                        Divider(thickness:1 ,color: darkTheme ? Colors.yellow : Colors.green,),

                        const SizedBox(height: 10,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.userRideRequestInformation!.userName!,
                              style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 20, color: darkTheme? Colors.yellow:Colors.blue
                              ),
                            ),
                            IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.phone, color: darkTheme ? Colors.yellow: Colors.green,size: 35,),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                         children: [
                           Image.asset("images/userOrigin.png",width: 30,height: 30,),

                        const SizedBox(width: 10,),

                        Expanded(
                            child: Container(
                              child: Text(
                                widget.userRideRequestInformation!.originAddress!,
                                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold,color: darkTheme? Colors.yellow:Colors.green),
                              ),
                            )
                          ),
                         ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Image.asset("images/userDestination.png",width: 30,height: 30,),

                            const SizedBox(width: 10,),

                            Expanded(
                                child: Container(
                                  child: Text(
                                    widget.userRideRequestInformation!.destinationAddress!,
                                    style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold,color: darkTheme? Colors.yellow:Colors.green),
                                  ),
                                )
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Divider(
                          thickness: 1,
                          color: darkTheme? Colors.blue:Colors.green,
                        ),
                        const SizedBox(height: 10,),

                        ElevatedButton.icon (
                            onPressed: () async{
                              //[driver has arrived at user pickup location ] -Arrived Button
                              if(rideRequestStatus=="accepted"){
                                rideRequestStatus ="arrived";

                                FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestInformation!.rideRequestId!).child("status").set(rideRequestStatus);
                                setState(() {
                                  buttonTitle ="Let's Go";
                                  buttonColor=  Colors.lightGreen[800];
                                });

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) => ProgressDialog(message: "Loading...",),
                                );
                                drawPolyLineFromOriginToDestination(widget.userRideRequestInformation!.originLatLng!, widget.userRideRequestInformation!.destinationLatLng!,darkTheme);
                                Navigator.pop(context);
                              }
                              //user has been picked up from users current location  -lets Go Button
                              else if( rideRequestStatus =="arrived"){
                                rideRequestStatus="onTrip";
                                FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestInformation!.rideRequestId!).child("status").set(rideRequestStatus);

                                setState(() {
                                  buttonTitle ="End Trip";
                                  buttonColor=  Colors.red[900];

                                });
                              }
                              //[User and driver has reached drop-off locations ] -End trip button
                              else if(rideRequestStatus=="onTrip"){
                                endTripNow();
                              }
                            },
                            icon: Icon(Icons.directions_car,color: darkTheme ? Colors.blue[800]: Colors.purple[800],),
                            label: Text(
                              buttonTitle!,
                              style: GoogleFonts.lato(color: darkTheme? Colors.blue: Colors.green[900],fontWeight: FontWeight.bold,fontSize: 14),
                            ),
                        ),
                    ],
                    ),
                  ),
                ),
              ),
          )
        ],
      ),
    );
  }
}