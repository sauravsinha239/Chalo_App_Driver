import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';
import '../widgets/historyDesignUi.dart';

class TripsHistoryScreen extends StatefulWidget{
  const TripsHistoryScreen({super.key});

  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    
  bool darkTheme= MediaQuery.of(context).platformBrightness == Brightness.dark;
  return Scaffold(
    backgroundColor: darkTheme ? Colors.lightBlue[700]: Colors.lightBlue[100],
    appBar: AppBar(
      backgroundColor: darkTheme? Colors.black: Colors.white,
      title: Text(
        "Trips History",
            style: GoogleFonts.niconne(color: darkTheme? Colors.deepOrange: Colors.purple[900], fontWeight: FontWeight.bold, fontSize: 34),
      ),
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.red,size: 34,),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      elevation: 0,
    ),
    body: Padding(
      padding: EdgeInsets.all(20),

      child: ListView.separated(
          itemBuilder: (context, i) {
            return Card(
              color:darkTheme? Colors.lightBlue[900]:Colors.lightBlue[100],
              shadowColor: Colors.transparent,
              child: HistoryDesignUi(
                tripsHistoryModel: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList[i],
              ),
            );
          },
          separatorBuilder: (context ,i)=> const SizedBox(height: 30,),
          itemCount:Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length ?? 0,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    ),

  );


  }
}