import 'dart:async';

import 'package:drivers/splash_screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'Theme_provider/theme_provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'global/global.dart';
import 'infoHandler/app_info.dart';
import 'model/user_model.dart';

Future <void> main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const Splash(
        ),
      ),
    );
  }

}
