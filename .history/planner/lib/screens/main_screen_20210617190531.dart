import 'package:MyUni/screens/pageviews/calendar_screen.dart';
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyUni/screens/pageviews/bulletin_screen.dart';
import 'package:MyUni/screens/pageviews/home_screen.dart';
import 'package:MyUni/screens/pageviews/profile.dart';
import 'package:MyUni/screens/pageviews/timetable.dart';
import 'package:flutter/rendering.dart';

class MainScreen extends StatefulWidget {
  final titles = ['Main', 'Timetable', 'Calendar', 'Bulletins', 'Profile'];
  final colors = [
    Colors.red[400],
    Colors.blue[800],
    Colors.blue[500],
    Colors.yellow[800],
    Colors.green[800]
  ];
  final icons = [
    CupertinoIcons.home,
    CupertinoIcons.time,
    CupertinoIcons.calendar,
    CupertinoIcons.rectangle_3_offgrid,
    CupertinoIcons.profile_circled
  ];

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    Homepage(),
    Timetable(),
    Calendar(),
    Bulletin(),
    Profile()
  ];

  @override
  void initState() {
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);

    super.initState();
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification &&
        scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            checkUserDragging(scrollNotification);
          },
          child: PageView(
            controller: _pageController,
            children:
                _widgetOptions.map((c) => Container(child: c)).toList(),
                // widget.colors.map((Color c) => Container(color: c)).toList(),
            onPageChanged: (page) {
            },
          ),
        ),
        bottomNavigationBar: BubbledNavigationBar(
          controller: _menuPositionController,
          initialIndex: _selectedIndex,
          itemMargin: EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: Colors.white,
          defaultBubbleColor: Colors.blue,
          onTap: (index) {
            _pageController.animateToPage(index,
                curve: Curves.easeInOutQuad,
                duration: Duration(milliseconds: 500));
          },
          items: widget.titles.map((title) {
            var index = widget.titles.indexOf(title);
            var color = widget.colors[index];
            return BubbledNavigationBarItem(
              icon: getIcon(index, color),
              activeIcon: getIcon(index, Colors.white),
              bubbleColor: color,
              title: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }).toList(),
        ));
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Icon(widget.icons[index], size: 30, color: color),
    );
  }
}
