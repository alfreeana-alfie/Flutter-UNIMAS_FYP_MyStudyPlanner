import 'package:flutter/material.dart';
import 'package:MyUni/pages/bulletin/bulletin_general.dart';
import 'package:MyUni/pages/bulletin/bulletin_personal.dart';

class Bulletin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow[900],
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'General'),
                Tab(text: 'Personal')
              ],
            ),
            title: Text('Bulletin')
          ),
          body: TabBarView(
            children: [
              General(),
              Personal()
            ],
          ),
        ),
      )
    );
  }
}
