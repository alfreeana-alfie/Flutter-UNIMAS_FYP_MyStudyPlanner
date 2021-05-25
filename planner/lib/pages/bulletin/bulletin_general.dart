import 'package:flutter/material.dart';
import 'package:MyUni/models/News.dart';
import 'package:MyUni/pages/bulletin/bulletin_details.dart';
import 'package:MyUni/pages/bulletin/bulletin_personal.dart';

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  List<News> announcements = [
    News(
        id: 1,
        title: 'TMI4013 - DATA MINING',
        description: 'Lecture class will be held on Tue, 14 Nov 2020.',
        createdAt: '10-10-2020'),
    News(
        id: 2,
        title: 'TMI4014 - DATA MINING',
        description: 'Lecture class will be held on Tue, 14 Nov 2020.',
        createdAt: '10-10-2020')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        scrollDirection: Axis.vertical,
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print("${index}");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BulletinDetails(announcements: announcements[index]))
                );
              },
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Column(
                    children: [
                      Text(announcements[index].title),
                      Text(announcements[index].description),
                      Text(announcements[index].createdAt),
                    ],
                  ),
                ),
              ),
            ),
            dense: false,
          );
        },
      ),
    );
  }
}