import 'dart:io';
import 'package:MyUni/auth/sign_in.dart';
import 'package:MyUni/screens/main_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
//   

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.red[800],
      home: SplashScreenView(
        navigateRoute: status == true ? MainScreen() : Login(),
        duration: 7000,
        imageSize: 200,
        imageSrc: "images/logo.png",
        text: "Enter a beautiful world",
        textType: TextType.ColorizeAnimationText,
        textStyle: GoogleFonts.openSansCondensed(
            textStyle: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: Colors.white,)),
        colors: [
          Colors.white,
          Colors.yellow[800],
          Colors.red[800],
          Colors.white,
        ],
        backgroundColor: Colors.red[800],
        pageRouteTransition: PageRouteTransition.SlideTransition,
      ),
    ),
  );
}
