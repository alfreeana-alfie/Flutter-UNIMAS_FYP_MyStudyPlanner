import 'dart:io';
import 'package:MyUni/auth/sign_in.dart';
import 'package:MyUni/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  
  // print(status);

  // runApp(MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   home: status == true ? MainScreen() : Login(),
  // ));

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.timer(
      seconds: 14,
      navigateAfterSeconds: status == true ? MainScreen() : Login(),
      title: Text(
        'Welcome In SplashScreen',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.network(
        'https://flutter.io/images/catalog-widget-placeholder.png',
      ),
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}