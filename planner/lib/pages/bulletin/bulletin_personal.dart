import 'package:flutter/material.dart';
import 'package:MyUni/models/News.dart';
import 'package:MyUni/pages/bulletin/bulletin_details.dart';

class Personal extends StatelessWidget {
  List<News> announcements = [
    News(
        id: 1,
        title: 'TMI4013 - DATA MINING',
        description: 'Lecture class will be held on Tue, 14 Nov 2020.',
        created_at: '10-10-2020'),
    News(
        id: 2,
        title: 'TMI4014 - DATA MINING',
        description: 'Lecture class will be held on Tue, 14 Nov 2020.',
        created_at: '10-10-2020')
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
                      Expanded(
                        flex: 1,
                        child: Text(announcements[index].title),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(announcements[index].description)
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(announcements[index].created_at)
                      )
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