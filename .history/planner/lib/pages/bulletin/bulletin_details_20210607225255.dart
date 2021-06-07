import 'package:flutter/material.dart';
import 'package:MyUni/models/News.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
        body: buildMainContainer());
  }

  Widget buildMainContainer() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Card(
        margin: EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  announcements.title,
                  style: GoogleFonts.openSansCondensed(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
              margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
              child: Divider(
                thickness: 2,
                height: 10,
                color: Colors.orange[800],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(DateFormat('MM/dd/yyyy hh:mm a').format(
                      DateFormat("yyyy-MM-dd hh:mm").parse(
                          DateTime.parse(messageList[index].created_at)
                              .toString()),
                  style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Posted by ${announcements.postedBy}',
                  style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
