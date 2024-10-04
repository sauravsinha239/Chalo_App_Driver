import 'package:flutter/material.dart';

class AccountsTab extends StatefulWidget{
  const AccountsTab({super.key});

  @override
  State<AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("AccountsTab",
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