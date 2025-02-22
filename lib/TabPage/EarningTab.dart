
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../global/global.dart';
import '../infoHandler/app_info.dart';
import '../screen/tripsHistoryScreen.dart';

class EarningTab extends StatefulWidget{
  const EarningTab({super.key});

  @override
  State<EarningTab> createState() => _EarningTabState();
}

class _EarningTabState extends State<EarningTab> {

  @override
  Widget build(BuildContext context) {

    bool darkTheme= MediaQuery.of(context).platformBrightness == Brightness.dark;


    return Container(
      color: darkTheme ? Colors.lightBlue[700] : Colors.lightBlue[100],
      child: Column(
        children: [
          Container(
            color: darkTheme ? Colors.black : Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                children: [
                  Text("Your Earnings",
                    style: GoogleFonts.niconne(color: darkTheme? Colors.green: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    "₹${double.parse(Provider.of<AppInfo>(context, listen: false).driverTotalEarnings).toStringAsFixed(2)}",
                    style: GoogleFonts.lato(
                      color: darkTheme? Colors.blue[500]: Colors.orange[600],
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),

                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60,),

          ElevatedButton(

              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (C)=> const TripsHistoryScreen()));
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[700],

              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Image.asset(
                      onlineDriverData.vehicleType =="car"? "images/car.png"
                          : onlineDriverData.vehicleType=="cng" ? "images/cng.png"
                          :"images/bike.png",
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      "Trips Completed",
                      style: GoogleFonts.niconne(fontSize: 34,
                          color: Colors.white),
                    ),
                    Expanded(
                        child: Text(
                            Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length.toString(),
                          textAlign: TextAlign.end,
                          style: GoogleFonts.niconne(
                              fontSize:34,
                              color: Colors.white
                          ),
                        )
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );

  }

}