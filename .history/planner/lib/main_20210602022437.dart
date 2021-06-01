import 'dart:io';
import 'package:MyUni/auth/sign_in.dart';
import 'package:MyUni/pages/add_lesson.dart';
import 'package:MyUni/pages/main_screen.dart';
import 'package:MyUni/pages/timetable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var status = prefs.getBool('isLoggedIn') ?? false;
  print(status);

  // runApp(MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   home: Login(),
  // ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: status == true ? Main() : Login(),
  ));
}