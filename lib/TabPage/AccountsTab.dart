import 'package:drivers/screen/VehicleDetailsUpdateScreen.dart';
import 'package:drivers/screen/main_page.dart';
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

@override

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness== Brightness.dark;


    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();

      },
      child: Scaffold(
        backgroundColor: darkTheme? Colors.lightBlue[800]:Colors.lightBlue[200],

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
                color: Colors.green,
                fontWeight:
                FontWeight.bold,
                fontSize: 38),
          ),centerTitle: true,

          elevation: 0.0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),

                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(60),
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white,),
                    ),
                    const SizedBox(height: 70,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Name : ${userModelCurrentInfo!.name!}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.laila(
                              fontSize: 22,
                              color:  Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            showUserNameDialogAlert(context, userModelCurrentInfo!.name!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.purple,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    //phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Phone : ${userModelCurrentInfo!.phone!}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.laila(
                              fontSize: 22,
                              color:  Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            showUserPhoneDialogAlert(context, userModelCurrentInfo!.phone!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.purple,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    //Address
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Address : ${userModelCurrentInfo!.address!}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.laila(
                              fontSize: 22,
                              color:  Colors.black,
                            ),
                          
                          ),
                        ),
                        IconButton(
                          onPressed: (){

                            showUserAddressDialogAlert(context, userModelCurrentInfo!.address!);
                          },
                          icon: const Icon(
                            Icons.edit, color: Colors.purple,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.3,),
                    Text(userModelCurrentInfo!.email!,
                      style:  GoogleFonts.laila(
                        fontSize: 20,
                        color:  Colors.purple ,
                      ),
                    ),
                    const SizedBox(height: 50,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>VehicleDetailsUpdateScreen()));
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Colors.blue[600],
                        ),
                      child: Text( "Vehicle Details",
                      style: GoogleFonts.niconne(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),

                    ),
                    const SizedBox(height: 60,),
                    ElevatedButton(
                      onPressed: (){
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.blue[600],
                      ),
                      child: Text( "Log out",
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