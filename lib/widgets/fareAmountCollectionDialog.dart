
import 'package:drivers/splash_screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FareAmountCollectionDialog extends StatefulWidget{

  double? totalFareAmount;

  FareAmountCollectionDialog({super.key, this.totalFareAmount});

  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();

}

class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog> {

  @override
  Widget build(BuildContext context) {
    bool darkTheme=MediaQuery.of(context).platformBrightness== Brightness.dark;
    return Dialog(
      shape:RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: darkTheme ? Colors.purple : Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            Text(
              //Trip fare Amount
              "Trip Fare Amount",
              style: GoogleFonts.lato(fontSize: 25, fontWeight: FontWeight.bold,color: darkTheme? Colors.yellow: Colors.white),

            ),
            Text(
              "₹${widget.totalFareAmount}",
              style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 60,color: darkTheme? Colors.yellow: Colors.white),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding:const EdgeInsets.all(8),
              child: Text(
                "This is Total trip Amount. \nPlease collect it from the user",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 14,color: darkTheme? Colors.black87: Colors.yellow,fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(height: 10,),

            Padding(
                padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkTheme ? Colors.indigoAccent:Colors.white,
                ),
                onPressed: (){
                  Future.delayed(const Duration(milliseconds: 2000),(){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const Splash()));
                  });
                },
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Collect Cash :",
                    style: GoogleFonts.lato(color: darkTheme ?Colors.yellow: Colors.deepPurpleAccent,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                    ),
                    Icon(Icons.currency_rupee_rounded,color: darkTheme? Colors.yellow: Colors.deepPurpleAccent,size: 30,),
                    Text(
                      widget.totalFareAmount.toString(),
                      style: GoogleFonts.lato(fontSize: 25, fontWeight: FontWeight.bold,color: darkTheme? Colors.yellow: Colors.deepPurpleAccent),
                    ),



                  ],
                ) ,
              )
            )
          ],
        ),
      ),

    );
  }
}