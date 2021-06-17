import 'dart:io';
import 'package:MyUni/auth/sign_in.dart';
import 'package:MyUni/pages/main_screen.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

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

  // runApp(
  //   MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     color: Colors.red[800],
  //     home: Container(
  //       color: Colors.red[800],
  //       child: AnimatedSplash(
  //       imagePath: 'images/logo.png',
  //       home: status == true ? MainScreen() : Login(),
  //       duration: 2500,
  //       type: AnimatedSplashType.StaticDuration,
  //     ),
  //     ),
  //   ),
  // );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.red[800],
      home: SplashScreenView(
        navigateRoute: status == true ? MainScreen() : Login(),
        duration: 5000,
        imageSize: 200,
        imageSrc: "images/logo.png",
        text: "MyUni Planner",
        textType: TextType.TyperAnimatedText,
        textStyle: TextStyle(
          fontSize: 50.0,
        ),
        colors: [
          Colors.purple,
          Colors.blue,
          Colors.yellow,
          Colors.red,
        ],
        backgroundColor: Colors.red[800],
      ),
    ),
  );
}
