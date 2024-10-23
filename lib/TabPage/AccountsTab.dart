import 'package:drivers/TabPage/HomeTab.dart';
import 'package:drivers/model/driverInfo.dart';
import 'package:drivers/screen/main_page.dart';
import 'package:drivers/widgets/getDriverData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../screen/login_screen.dart';

class AccountsTab extends StatefulWidget{
  const AccountsTab({super.key});



  @override
  State<AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab> {

  final nameTextEditor= TextEditingController();
  final phoneTextEditor= TextEditingController();
  final addressTextEditor= TextEditingController();
  final vehicleTypeTextEditor= TextEditingController();
  final modelTextEditor= TextEditingController();
  final numberTextEditor= TextEditingController();
  final colorTextEditor= TextEditingController();

  DatabaseReference userRef= FirebaseDatabase.instance.ref().child("drivers");


  Future<void> showUserNameDialogAlert(BuildContext context, String name){
    nameTextEditor.text =name;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: const Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditor,
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

                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name" : nameTextEditor.text.trim(),
                  }).then((value){
                    // change state
                    setState(() {
                      userModelCurrentInfo!.name = nameTextEditor.text.trim();
                    });
                    nameTextEditor.clear();
                    Fluttertoast.showToast(msg: "Modified Succesfully.");

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
  //Phone update dialog
  Future<void> showUserPhoneDialogAlert(BuildContext context, String Phone){
    phoneTextEditor.text =Phone;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: const Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneTextEditor,
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

                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "phone" : phoneTextEditor.text.trim(),
                  }).then((value){
                    setState(() {
                      userModelCurrentInfo!.phone = phoneTextEditor.text.trim();
                    });
                    phoneTextEditor.clear();
                    Fluttertoast.showToast(msg: "Modified Succesfully.");

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
  //Address update dialog
  Future<void> showUserAddressDialogAlert(BuildContext context, String address) {
    addressTextEditor.text = address;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: addressTextEditor,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "address": addressTextEditor.text.trim(),
                  }).then((value) {
                    setState(() {
                      userModelCurrentInfo!.address = addressTextEditor.text
                          .trim();
                    });
                    addressTextEditor.clear();
                    Fluttertoast.showToast(msg: "Modified Successfully.");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(
                        msg: "Error Occurred!. \n $errorMessage");
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

@override

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness== Brightness.dark;


    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();

      },
      child: Scaffold(

        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (C)=> MainPage()));
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.red,size: 22,),
          ),
          title:  Text(
            "Account",
            style: GoogleFonts.niconne(
                color: Colors.yellowAccent,
                fontWeight:
                FontWeight.bold,
                fontSize: 38),
          ),centerTitle: true,

          elevation: 0.0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),

                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white,),
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Name : ${userModelCurrentInfo!.name!}",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.yellow: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            showUserNameDialogAlert(context, userModelCurrentInfo!.name!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    //phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phone : ${userModelCurrentInfo!.phone!}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.yellow: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            showUserPhoneDialogAlert(context, userModelCurrentInfo!.phone!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    //Address
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Address : ${userModelCurrentInfo!.address!}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.yellow: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: (){

                            showUserAddressDialogAlert(context, userModelCurrentInfo!.address!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Vehicle Type : ${onlineDriverData.vehicleType!.toUpperCase()}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.yellow: Colors.green,
                          ),
                        ),  Image.asset(
                                  onlineDriverData.vehicleType =="car"? "images/car.png"
                                  : onlineDriverData.vehicleType=="cng" ? "images/cng.png"
                                  :"images/bike.png",
                                width: 40,
                                height: 40,
                              ),

                        IconButton(
                          onPressed: (){

                            showVehicleTypeDialogAlert(context, onlineDriverData.vehicleType!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Vehicle Color : ${onlineDriverData.vehicleColor!}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.yellow: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: (){

                            showVehicleColorDialogAlert(context, onlineDriverData.vehicleColor!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Vehicle Model : ${onlineDriverData.vehicleModel!}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.yellow: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: (){

                            showVehicleModelDialogAlert(context, onlineDriverData.vehicleModel!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Vehicle Number : ${onlineDriverData.vehicleNumber!}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTheme ? Colors.yellow: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: (){

                            showVehicleNumberDialogAlert(context, onlineDriverData.vehicleNumber!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    Text(userModelCurrentInfo!.email!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:  Colors.green ,
                      ),
                    ),

                    const SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: (){
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Colors.blue[600],
                        ),
                      child: Text( "Sign out",
                      style: GoogleFonts.niconne(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),

                    ),
                  ],

                ),
              ),
            )
          ],
        ),


      ),
    );
  }
}