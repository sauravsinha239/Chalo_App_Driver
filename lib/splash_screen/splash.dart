
import 'dart:async';
import 'package:drivers/pushNotification/notificationDialogBox.dart';
import 'package:drivers/screen/vehicleScreenInformation.dart';
import 'package:flutter/material.dart';

import '../Assistants/assistant.dart';
import '../global/global.dart';
import '../screen/login_screen.dart';
import '../screen/main_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTimer(){
    Timer(const Duration(seconds:2) ,()async{

      if(firebaseAuth.currentUser!=null)
        {
          firebaseAuth.currentUser!= null ? Assistants.readCurrentOnlineUserInfo(): null;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> MainPage()));
        }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(c)=>const LoginScreen()));
      }
    });
  }
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: Text(
          "Chalo",
          style: TextStyle(
            fontWeight: FontWeight.bold,fontSize: 40,
          ),
        ),
      ),

    );
  }


}
