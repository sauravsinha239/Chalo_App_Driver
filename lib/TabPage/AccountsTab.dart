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
                    Fluttertoast.showToast(msg: "Modified Succesfully.");
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
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.red,size: 22,),
          ),
          title: const Text(
            "Account",
            style: TextStyle(
                color: Colors.yellowAccent,
                fontWeight:
                FontWeight.bold,
                fontSize: 28),
          ),centerTitle: true,

          elevation: 0.0,
        ),
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 50),

                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(50),
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white,),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userModelCurrentInfo!.name!,
                          style: TextStyle(
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
                    const Divider(
                      thickness: 1,

                    ),
                    //phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userModelCurrentInfo!.phone!,
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
                    const Divider(
                      thickness: 1,
                    ),
                    //Address
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userModelCurrentInfo!.address!,
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
                    const Divider(
                      thickness: 1,
                    ),
                    Text(userModelCurrentInfo!.email!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:  Colors.green ,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Model: ${onlineDriverData.vehicleModel}\nReg No: ${onlineDriverData.vehicleNumber}",
                          style: GoogleFonts.lato(color: darkTheme? Colors.yellow: Colors.yellow, fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        Image.asset(
                            onlineDriverData.vehicleType =="car"? "images/car.png"
                            : onlineDriverData.vehicleType=="cng" ? "images/cng.png"
                            :"images/bike.png",
                          width: 80,
                          height: 80,
                        )
                      ],
                    ),
                    SizedBox(height: 80,),
                    ElevatedButton(
                      onPressed: (){
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Colors.blue[600],
                        ),
                      child: Text( "Signout",
                      style: GoogleFonts.lato(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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