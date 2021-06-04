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
      body: buildMainContainer()
    );
  }

  Widget buildMainContainer() {
    return Card(
      child: Container(
        chid
      ),
    );
  }
}
