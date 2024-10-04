import 'package:flutter/material.dart';

class EarningTab extends StatefulWidget{
  const EarningTab({super.key});

  @override
  State<EarningTab> createState() => _EarningTabState();
}

class _EarningTabState extends State<EarningTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Earning Tab",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),

    ),
    ),
      body: Container(
        child: Text(
          "Hello",
        ),
      ),
    );
 
  }
}