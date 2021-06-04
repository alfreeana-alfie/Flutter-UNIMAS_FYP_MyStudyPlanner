import 'package:flutter/material.dart';
import 'package:MyUni/models/News.dart';
import 'package:google_fonts/google_fonts.dart';

class BulletinDetails extends StatelessWidget {
  final News announcements;

  BulletinDetails({Key key, this.announcements}) : super(key: key);

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: Text('News'),
          backgroundColor: Colors.yellow[900]),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 50, 5, 5),
        child: Column(
          children: [
            Text(announcements.description),
            Container(child: Text("Posted by ${announcements.postedBy}")),
          ],
        ),
      ),
    );
  }

  Widget buildMainContainer() {
    return Card(
      child: Container(
        child: Column(
          children: [
            Text(
              announcements.title, 
              style: GoogleFonts.openSansCondensed(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
