import 'dart:io';
import 'package:MyUni/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:MyUni/auth/sign_in.dart';
import 'package:MyUni/pages/main_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp( MaterialApp (
      debugShowCheckedModeBanner: false,
      home: Login(),
    )
  );
}