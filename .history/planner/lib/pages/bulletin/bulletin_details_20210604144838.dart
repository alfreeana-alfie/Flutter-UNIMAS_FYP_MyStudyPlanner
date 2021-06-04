import 'package:flutter/material.dart';
import 'package:MyUni/models/News.dart';

class BulletinDetails extends StatelessWidget {
  final News announcements;

  BulletinDetails({Key key, this.announcements}) : super(key: key);

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(announcements.title),
            backgroundColor: Colors.yellow[900]),
        body: Padding(
            padding: EdgeInsets.fromLTRB(15, 50, 5, 5),
            child: Column(
              children: [
                Text(announcements.description),
                Container(child: Text("Posted by ${announcements.postedBy}")),
              ],
            ),),);
  }

  Widget buildMainContainer() {
    return Card(

    );
  }
}
