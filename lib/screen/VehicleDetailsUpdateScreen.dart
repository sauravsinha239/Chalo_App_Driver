import 'package:drivers/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleDetailsUpdateScreen extends StatefulWidget{
  const VehicleDetailsUpdateScreen({super.key});

  @override
  State<VehicleDetailsUpdateScreen> createState() => _VehicleDetailsUpdateScreenState();
}

class _VehicleDetailsUpdateScreenState extends State<VehicleDetailsUpdateScreen> {
  final vehicleTypeTextEditor= TextEditingController();
  final modelTextEditor= TextEditingController();
  final numberTextEditor= TextEditingController();
  final colorTextEditor= TextEditingController();
  DatabaseReference userRef= FirebaseDatabase.instance.ref().child("drivers");
  @override
  //Vehicle Type update
  Future<void> showVehicleTypeDialogAlert(BuildContext context, String vehicle){
    vehicleTypeTextEditor.text =vehicle;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title:  Text("Update", style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold),),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: vehicleTypeTextEditor,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: (){

                  userRef.child(firebaseAuth.currentUser!.uid).child("vehicleDetails").update({
                    "vehicleType" : vehicleTypeTextEditor.text.trim().toLowerCase(),
                  }).then((value){
                    // change state
                    setState(() {
                      onlineDriverData.vehicleType= vehicleTypeTextEditor.text.trim();

                    });
                    vehicleTypeTextEditor.clear();
                    Fluttertoast.showToast(msg: "Modified Successfully.");

                  }).catchError((errorMessage){
                    Fluttertoast.showToast(msg: "Error Occurred!. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: const Text("Ok", style: TextStyle(color: Colors.green),),
              ),
            ],
          );
        }
    );
  }
  //vehicle color
  Future<void> showVehicleColorDialogAlert(BuildContext context, String color){
    colorTextEditor.text =color;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title:  Text("Update", style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold),),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: colorTextEditor,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: (){

                  userRef.child(firebaseAuth.currentUser!.uid).child("vehicleDetails").update({
                    "vehicleColor" : colorTextEditor.text.trim(),
                  }).then((value){
                    // change state
                    setState(() {
                      onlineDriverData.vehicleColor= colorTextEditor.text.trim();

                    });
                    colorTextEditor.clear();
                    Fluttertoast.showToast(msg: "Modified Successfully.");

                  }).catchError((errorMessage){
                    Fluttertoast.showToast(msg: "Error Occurred!. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: const Text("Ok", style: TextStyle(color: Colors.green),),
              ),
            ],
          );
        }
    );
  }
  //VehicleModel
  Future<void> showVehicleModelDialogAlert(BuildContext context, String model){
    modelTextEditor.text =model;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title:  Text("Update", style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold),),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: modelTextEditor,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: (){

                  userRef.child(firebaseAuth.currentUser!.uid).child("vehicleDetails").update({
                    "vehicleModel" : modelTextEditor.text.trim(),
                  }).then((value){
                    // change state
                    setState(() {
                      onlineDriverData.vehicleModel= modelTextEditor.text.trim();

                    });
                    modelTextEditor.clear();
                    Fluttertoast.showToast(msg: "Modified Successfully.");

                  }).catchError((errorMessage){
                    Fluttertoast.showToast(msg: "Error Occurred!. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: const Text("Ok", style: TextStyle(color: Colors.green),),
              ),
            ],
          );
        }
    );
  }
  //VehicleNumber
  Future<void> showVehicleNumberDialogAlert(BuildContext context, String number){
    numberTextEditor.text =number;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title:  Text("Update", style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold),),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: numberTextEditor,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: (){

                  userRef.child(firebaseAuth.currentUser!.uid).child("vehicleDetails").update({
                    "vehicleNumber" : numberTextEditor.text.trim(),
                  }).then((value){
                    // change state
                    setState(() {
                      onlineDriverData.vehicleNumber= numberTextEditor.text.trim();

                    });
                    numberTextEditor.clear();
                    Fluttertoast.showToast(msg: "Modified Successfully.");

                  }).catchError((errorMessage){
                    Fluttertoast.showToast(msg: "Error Occurred!. \n $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: const Text("Ok", style: TextStyle(color: Colors.green),),
              ),
            ],
          );
        }
    );
  }

  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: darkTheme ? Colors.lightBlue[700]: Colors.lightBlue[200],

      appBar: AppBar(
        title: Text("Vehicle Details",
          style: GoogleFonts.niconne(
            fontSize: 38, fontWeight: FontWeight.bold,
            color: darkTheme ? Colors.yellow:Colors.green,
          ),
        ),centerTitle: true,
        backgroundColor: darkTheme ? Colors.black12:Colors.white24,
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
              child: Column(
                children: [
                  Image.asset(
                    onlineDriverData.vehicleType =="car"? "images/car.png"
                        : onlineDriverData.vehicleType=="cng" ? "images/cng.png"
                        :"images/bike.png",
                    width: 300,
                    height: 250,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("Vehicle Type : ${onlineDriverData.vehicleType!.toUpperCase()}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.laila(
                            fontSize: 22,
                            color: darkTheme ? Colors.white: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){

                          showVehicleTypeDialogAlert(context, onlineDriverData.vehicleType!);
                        },
                        icon: const Icon(
                          Icons.edit, color: Colors.purple,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("Vehicle Color : ${onlineDriverData.vehicleColor!}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.laila(
                            fontSize: 22,
                            color: darkTheme ? Colors.white: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){

                          showVehicleColorDialogAlert(context, onlineDriverData.vehicleColor!);
                        },
                        icon: const Icon(
                          Icons.edit, color: Colors.purple,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness:2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("Vehicle Model : ${onlineDriverData.vehicleModel!}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.laila(
                           fontSize: 22,
                           color: darkTheme ? Colors.white: Colors.black,
                             ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){

                          showVehicleModelDialogAlert(context, onlineDriverData.vehicleModel!);
                        },
                        icon: const Icon(
                          Icons.edit, color: Colors.purple,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("Vehicle Number : ${onlineDriverData.vehicleNumber!}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.laila(
                            fontSize: 22,
                            color: darkTheme ? Colors.white: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){

                          showVehicleNumberDialogAlert(context, onlineDriverData.vehicleNumber!);
                        },
                        icon: const Icon(
                          Icons.edit, color: Colors.purple,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness:2,),
                  SizedBox(height: 10,),
                  Text(userModelCurrentInfo!.email!,
                    style: GoogleFonts.laila(
                      fontSize: 22,
                      color:  Colors.purple,
                    ),
                  ),

                ],

              ),
            ),
          )
        ],

      ),
    );
  }
}