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
    home: FadeTransitionSample()));
}

class FadeTransitionSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Fade();
}

class _Fade extends State<FadeTransitionSample> with TickerProviderStateMixin {
  AnimationController animation;
  Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.5).animate(animation);

    // animation.addStatusListener((status){
    //   if(status == AnimationStatus.completed){
    //     animation.reverse();
    //   }
    //   else if(status == AnimationStatus.dismissed){
    //     animation.forward();
    //   }
    // });
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: SplashScreen(
            seconds: 3,
            navigateAfterSeconds: Login,
            title: Text('MyUni Planner System',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSansCondensed(
                    textStyle: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.2,
                        color: Colors.white))),
            backgroundColor: Colors.red[800],
            loaderColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AfterSplash(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
