import 'package:flutter/material.dart';
import 'package:MyUni/pages/bulletin/bulletin_general.dart';
import 'package:MyUni/pages/bulletin/bulletin_personal.dart';
import 'package:google_fonts/google_fonts.dart';

class Bulletin extends StatelessWidget {
  //Widgets
  Widget buildMainContainer() {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 60, 0, 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Bulletin',
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: Colors.orange[800]))),
                  ),
                ),
              ],
            ),
            buildTabContainer()
          ],
        ));
  }

  Widget buildTabContainer() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
        child: MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.directions_car)),
                    Tab(icon: Icon(Icons.directions_transit)),
                    Tab(icon: Icon(Icons.directions_bike)),
                  ],
                ),
                Container(
                  child: TabBarView(
                    children: [
                      Icon(Icons.directions_car),
                      Icon(Icons.directions_transit),
                      Icon(Icons.directions_bike),
                    ],
                  ),
                )
              ],
            )
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.topLeft,
              child:  Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Text('Bulletin',
                  style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                    )
                  )
                ),
              )
            ),
            backgroundColor: Colors.orange[800],
            elevation: 0,
            bottom: TabBar(
                labelColor: Colors.orange[800],
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("GENERAL"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("PERSONAL"),
                    ),
                  ),
                ]
            ),
          ),
          body: TabBarView(
            children: [
              General(),
              Personal(),
            ]
          ),
        )
      )
    );
  }
}