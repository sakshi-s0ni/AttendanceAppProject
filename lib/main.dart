import 'package:attendance/screens/admin.dart';
import 'package:attendance/screens/generate.dart';
import 'package:attendance/screens/home.dart';
import 'package:attendance/screens/list.dart';
import 'package:attendance/screens/scan.dart';
import 'package:attendance/screens/showat.dart';
import 'package:attendance/screens/stu_reg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      bottomAppBarColor: Colors.white,
    ),
    debugShowCheckedModeBanner: false,
    //home: MyHome(),
    initialRoute: '/',
    routes: {
      '/': (context) => MyHome(),
      '/list': (context) => MyList(),
      '/addstu': (context) => AddStu(),
      '/admin': (context) => MyAdmin(),
      '/gen': (context) => GenerateScreen(),
      '/scan': (context) => ScanPage(),
      '/showat': (context) => ShowAt(),
    },
  ));
}
