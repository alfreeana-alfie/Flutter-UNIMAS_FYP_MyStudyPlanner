import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_letter/avatar_letter.dart';

import 'package:MyUni/models/News.dart';
import 'package:MyUni/models/Verify.dart';

import 'bulletin_details.dart';

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  // Variables
  List<News> dataNewsList = [];
  Map<String, dynamic> verifyMap;
  Map<String, dynamic> newsList;

  // Methods
  Future getAnnouncementList() async {
    Uri getAPILink =
        Uri.parse("https://hawkingnight.com/planner/public/api/get-news/0");

    final response =
        await http.get(getAPILink, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      verifyMap = jsonDecode(response.body);
      var verifyData = Verify.fromJSON(verifyMap);

      if (verifyData.status == "SUCCESS") {
        newsList = jsonDecode(response.body);
        for (var newsMap in newsList['news']) {
          final news = News.fromMap(newsMap);
          if (this.mounted) {
            dataNewsList.add(news);
          }
        }
      } else {
        print('Failed to fetch!');
      }
    } else {
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildMainContainer());
  }

  Widget buildMainContainer() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white])),
        child: Stack(
          children: [getNews()],
        ));
  }

  Widget buildNewsContent(News) {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              AvatarLetter(
                  size: 50,
                  backgroundColor: Colors.blue[100],
                  textColor: Colors.blue[300],
                  fontSize: 24,
                  upperCase: true,
                  numberLetters: 2,
                  letterType: LetterType.Rectangle,
                  text: News.title),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(News.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w900))),
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(News.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                          fontSize: 12,
                        ))),
                  )
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BulletinDetails(announcements: News)));
                },
                icon: Icon(Icons.arrow_right),
              ),
            ]),
            Divider(
              height: 2,
              thickness: ,
            )
          ],
        ));
  }

  Widget buildNewsList() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListView(
          padding: EdgeInsets.only(top: 10.0),
          children: dataNewsList.map((p) {
            return buildNewsContent(p);
          }).toList(),
        ));
  }

  Widget getNews() {
    return FutureBuilder(
      future: getAnnouncementList(),
      builder: (context, snapshot) {
        print(snapshot.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.orange[800],
            ),
          );
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ListView(
                  padding: EdgeInsets.only(top: 10.0),
                  children: dataNewsList.map((p) {
                    return buildNewsContent(p);
                  }).toList(),
                ));
        }
      },
    );
  }
}
