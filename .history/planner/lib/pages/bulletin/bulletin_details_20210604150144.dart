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
        padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [buildMainContainer()],
        ),
      ),
    );
  }

  Widget buildMainContainer() {
    return Card(
      child: Container(
        child: SingleChildScrollView(
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
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    announcements.description,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Posted at ${announcements.createdAt}',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Posted at ${announcements.postedBy}',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
