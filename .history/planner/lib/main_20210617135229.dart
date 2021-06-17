import 'dart:io';
import 'package:MyUni/auth/sign_in.dart';
import 'package:MyUni/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var status = prefs.getBool('isLoggedIn') ?? false;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(
      seconds: 14,
      navigateAfterSeconds: status == true ? MainScreen() : Login(),  
      title: Text(
        'MyUni Planner System',
        textAlign: TextAlign.center,
        style: GoogleFonts.openSansCondensed(
          textStyle: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.2,
            color: Colors.white
          )
        )
      ),
      backgroundColor: Colors.red[800],
      loaderColor: Colors.white,
    ),
  ));
}