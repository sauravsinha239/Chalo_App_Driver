import 'dart:async';

import 'package:drivers/TabPage/AccountsTab.dart';
import 'package:drivers/TabPage/EarningTab.dart';
import 'package:drivers/TabPage/HomeTab.dart';
import 'package:drivers/TabPage/RatingTab.dart';
import 'package:drivers/widgets/getDriverData.dart';
import 'package:flutter/material.dart';
class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectIndex = 0;
  onItemClicked(int index){
    setState(() {
      selectIndex=index;
      tabController!.index=selectIndex;
    });
  }
GetDriverData getDriverData  =GetDriverData();

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
    getDriverData.readCurrentDriverInformation();

  }


  @override

  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
           Hometab(),
           EarningTab(),
           RatingTab(),
           AccountsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:const [
          BottomNavigationBarItem(icon :Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon :Icon(Icons.credit_card),label: "Earnings"),
          BottomNavigationBarItem(icon :Icon(Icons.star_border),label: "Ratings"),
          BottomNavigationBarItem(icon :Icon(Icons.person),label: "Accounts"),

        ],
        unselectedItemColor: darkTheme? Colors.black: Colors.white,
        selectedItemColor: darkTheme ? Colors.yellow: Colors.red,
        backgroundColor: darkTheme? Colors.grey: Colors.brown,

        type:BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectIndex,
        onTap: onItemClicked,
      ),
    );

  }
}