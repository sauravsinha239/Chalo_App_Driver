import 'dart:developer';

import 'package:drivers/Theme_provider/theme_provider.dart';
import 'package:drivers/infoHandler/app_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import 'forget.dart';
import 'login_screen.dart';

class VehicleScrennInformation extends StatefulWidget{
  const VehicleScrennInformation({super.key});

  @override
  State<VehicleScrennInformation> createState() => _VehicleScrennInformationState();
}

class _VehicleScrennInformationState extends State<VehicleScrennInformation> {
  final vehicleModelTextEdit= TextEditingController();
  final vehicleNumberTextEdit= TextEditingController();
  final vehicleColorTextEdit= TextEditingController();

  List<String> vehicleTypes= ["Car","Cng", "Bike" ];

  String? selectedVehicleType;

  final _formkey =GlobalKey<FormState>();
  _Submit() async {
    if(_formkey.currentState!.validate()) {
      Map driverCarInfoMap = {
        "vehicleModel": vehicleModelTextEdit.text.trim(),
        "vehicleColor": vehicleColorTextEdit.text.trim(),
        "vehicleNumber": vehicleNumberTextEdit.text.trim(),
        "vehicleType": selectedVehicleType?.toLowerCase(),
      };

      DatabaseReference UserRef = FirebaseDatabase.instance.ref().child(
          "drivers");
      UserRef.child(currentUser!.uid).child("vehicleDetails").set(
          driverCarInfoMap);
      print("vehicle types log ${vehicleTypes}");
      print("Selected vehicle types ${selectedVehicleType}");
      await Fluttertoast.showToast(msg: "Vehicle Details Saved , Login now");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const LoginScreen()));
    }
    else {
    Fluttertoast.showToast(msg: "Not all Filed are valid !");
    }
  }

  @override
  Widget build(BuildContext context) {
    //themes
    bool darktheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

   return GestureDetector(
     onTap: (){
       FocusScope.of(context).unfocus();
     },
     child: Scaffold(
       body: ListView(
         padding:EdgeInsets.all(0),
         children: [
           Column(
             children: [
               Image.asset(darktheme ? 'images/citydark.jpg' : 'images/city.jpg'),
               SizedBox(height: 20,),
       Text(
         'Enter Vehicle Details',
         textAlign: TextAlign.center,
         style: TextStyle(
           color: darktheme ? Colors.amber.shade400:Colors.red,
           fontSize: 30,
           fontWeight: FontWeight.w600,
           fontStyle: FontStyle.italic,

         ),
       ),
               Padding(
                 padding: const EdgeInsets.fromLTRB(15,20,15,50),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Form(
                       key: _formkey,
                       child: Column(
                         children: [
                           TextFormField(
                             inputFormatters: [
                               LengthLimitingTextInputFormatter(50)
                             ],
                             decoration: InputDecoration(
                                 hintText: "Model!",
                                 hintStyle: const TextStyle(
                                   color: Colors.grey,
                                 ),
                                 filled: true,
                                 fillColor: darktheme ? Colors.black : Colors.white,
                                 border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(80),
                                     borderSide: const BorderSide(
                                       width: 0,
                                       style: BorderStyle.none,
                                     )
                                 ),
                                 prefixIcon: Icon(Icons.person,color: darktheme ? Colors.yellow : Colors.red,)

                             ),
                             autovalidateMode: AutovalidateMode.onUserInteraction,
                             validator: (text){
                               if(text == null || text.isEmpty)
                               {
                                 return "Model can`t be Empty";
                               }
                               if(text.length <4 || text.length>50 ){
                                 return "Please Enter Valid Model";
                               }
                               return null;
                             },
                             onChanged: (Text)=>setState(() {
                               vehicleModelTextEdit.text=Text;
                             }),
                           ),
                           SizedBox(height: 10,),
                           //car color
                           TextFormField(
                             inputFormatters: [
                               LengthLimitingTextInputFormatter(50)
                             ],
                             decoration: InputDecoration(
                                 hintText: "Color!",
                                 hintStyle: const TextStyle(
                                   color: Colors.grey,
                                 ),
                                 filled: true,
                                 fillColor: darktheme ? Colors.black : Colors.white,
                                 border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(80),
                                     borderSide: const BorderSide(
                                       width: 0,
                                       style: BorderStyle.none,
                                     )
                                 ),
                                 prefixIcon: Icon(Icons.person,color: darktheme ? Colors.yellow : Colors.red,)

                             ),
                             autovalidateMode: AutovalidateMode.onUserInteraction,
                             validator: (text){
                               if(text == null || text.isEmpty)
                               {
                                 return "Color can`t be Empty";
                               }
                               if(text.length <2 || text.length>25 ){
                                 return "Please Enter Valid Color";
                               }
                               return null;
                             },
                             onChanged: (Text)=>setState(() {
                               vehicleColorTextEdit.text=Text;
                             }),
                           ),
                           SizedBox(height: 10,),
                           // car Number
                           TextFormField(
                             inputFormatters: [
                               LengthLimitingTextInputFormatter(50)
                             ],
                             decoration: InputDecoration(
                                 hintText: "Number!",
                                 hintStyle: const TextStyle(
                                   color: Colors.grey,
                                 ),
                                 filled: true,
                                 fillColor: darktheme ? Colors.black : Colors.white,
                                 border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(80),
                                     borderSide: const BorderSide(
                                       width: 0,
                                       style: BorderStyle.none,
                                     )
                                 ),
                                 prefixIcon: Icon(Icons.person,color: darktheme ? Colors.yellow : Colors.red,)

                             ),
                             autovalidateMode: AutovalidateMode.onUserInteraction,
                             validator: (text){
                               if(text == null || text.isEmpty)
                               {
                                 return "Number can`t be Empty";
                               }
                               if(text.length <2 || text.length>25 ){
                                 return "Please Enter Valid Number";
                               }
                               return null;
                             },
                             onChanged: (Text)=>setState(() {
                               vehicleNumberTextEdit.text=Text;
                             }),
                           ),
                           SizedBox(height: 10,),

                           DropdownButtonFormField(
                             decoration: InputDecoration(
                               hintText: "Please Chose Vehicle Types!",
                               prefixIcon: Icon(Icons.car_crash, color: darktheme ? Colors.yellow: Colors.red,),

                               filled: true,
                               fillColor: darktheme ? Colors.black:Colors.white,

                             ),
                               items: vehicleTypes.map((car){
                                 return DropdownMenuItem(
                                     child: Text( car, style: TextStyle(color: Colors.grey),
                                 ),
                                   value: car,
                                 );
                               }).toList(),
                               onChanged: (newValue){
                                 setState(() {
                                   selectedVehicleType=newValue.toString();
                                 });
                               }
                           ),
                           SizedBox(height: 80,),

                           ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               backgroundColor: darktheme ? Colors.yellowAccent : Colors.red,
                               elevation: 0,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(20),
                               ),
                               minimumSize: const Size(200,40),

                             ),
                             onPressed: (){
                               _Submit();
                             }, child: const Text(
                             'Register',
                             style: TextStyle(
                               fontSize: 20,
                               fontWeight: FontWeight.bold,
                               color: Colors.purple,
                             ),

                           ),
                           ),
                           const SizedBox(height: 20,),
                           GestureDetector(
                             onTap: () {
                               Navigator.pushReplacement(context,MaterialPageRoute(builder:  (c)=>const forgetScreen()));
                             },
                             child: Text(
                               'Forget Password',
                               style: TextStyle(
                                 color: darktheme ? Colors.yellowAccent : Colors.red,
                                 fontSize: 20,
                               ),
                             ),

                           ),
                           const SizedBox(height: 10,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               const Text("Have an account?",
                                 style: TextStyle(
                                   color: Colors.grey,
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                 ),),
                               const SizedBox(width: 10,),
                               GestureDetector(
                                 onTap: (){
                                   Navigator.pushReplacement(context,MaterialPageRoute(builder: (c)=>const LoginScreen() ));
                                 },
                                 child: Text(
                                   "Sign in",
                                   style: TextStyle(
                                     fontSize: 15,
                                     color: darktheme ? Colors.grey :Colors.grey,
                                   ),
                                 ),
                               )
                             ],
                           )
                         ],
                       ),
                     ),
                   ],
                 ),
               )
         ],
           )
         ],
       ),
     ),
   );

  }
}