import 'package:flutter/material.dart';
import 'package:MyUni/pages/bulletin/bulletin.dart';
import 'package:MyUni/pages/calendar.dart';
import 'package:MyUni/pages/home.dart';
import 'package:MyUni/pages/profile.dart';
import 'package:MyUni/pages/timetable.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    Homepage(),
    Timetable(),
    SysCalendar(),
    Bulletin(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              label: 'Dashboard',
              backgroundColor: Colors.red[900],
              icon: Icon(Icons.dashboard),
              activeIcon: Icon(Icons.dashboard, color: Colors.white)),
          BottomNavigationBarItem(
              label: 'Timetable',
              backgroundColor: Colors.blue[900],
              icon: Icon(Icons.table_chart),
              activeIcon: Icon(Icons.table_chart, color: Colors.white)),
          BottomNavigationBarItem(
              label: 'Calendar',
              backgroundColor: Colors.blue[500],
              icon: Icon(Icons.calendar_today),
              activeIcon: Icon(Icons.calendar_today, color: Colors.white)),
          BottomNavigationBarItem(
              label: 'Bulletin',
              backgroundColor: Colors.yellow[900],
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list, color: Colors.white)),
          BottomNavigationBarItem(
              label: 'Profile',
              backgroundColor: Colors.green[900],
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person, color: Colors.white))
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
