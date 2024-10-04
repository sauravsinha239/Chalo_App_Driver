import 'package:flutter/material.dart';

class RatingTab extends StatefulWidget{
  const RatingTab({super.key});

  @override
  State<RatingTab> createState() => _RatingTabState();
}

class _RatingTabState extends State<RatingTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Rating Tab",
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