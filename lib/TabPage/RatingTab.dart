import 'package:drivers/infoHandler/app_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../global/global.dart';

class RatingTab extends StatefulWidget{
  const RatingTab({super.key});

  @override
  State<RatingTab> createState() => _RatingTabState();
}

class _RatingTabState extends State<RatingTab> {
  double ratingsNumber= 0;

  @override
  void initState() {

    super.initState();
    getRatingsNumber();
  }

  getRatingsNumber(){
    setState(() {
      ratingsNumber =double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings);
    });
    setupRatingsTitle();
  }
  setupRatingsTitle(){
    if(ratingsNumber==1){

      setState(() {
        titleStarRating= "Very Bad";
      });
    }
    if(ratingsNumber==2){
      setState(() {
        titleStarRating= "Bad";
      });
    }
    if(ratingsNumber==3){
      setState(() {
        titleStarRating= "Good";
      });
    }
    if(ratingsNumber==4){
      setState(() {
        titleStarRating= "Very Good";
      });
    }
    if(ratingsNumber==5){
      setState(() {
        titleStarRating= "Excellent";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    bool darkTheme= MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(

      backgroundColor: darkTheme? Colors.black: Colors.white,

      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: darkTheme ? Colors.grey: Colors.white,
        child: Container(
          margin: EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
            color: darkTheme? Colors.grey: Colors.pink,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22,),
              Text("Your Ratings",
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: darkTheme? Colors.yellow:Colors.green),
              ),
              SizedBox(height: 20,),
              SmoothStarRating(
                rating: ratingsNumber,
                allowHalfRating: true,
                starCount: 5,
                color: Colors.purple,
                borderColor: Colors.yellow,
                size: 60,

              ),
              SizedBox(height: 12,),
              Text(
                titleStarRating,
                style: GoogleFonts.lato(
                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              )
            ],
          ),
        ),
      ),

    );


    }

  }
