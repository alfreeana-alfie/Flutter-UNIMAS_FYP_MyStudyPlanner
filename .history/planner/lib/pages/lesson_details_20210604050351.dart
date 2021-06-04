import 'dart:convert';
import 'package:MyUni/models/Lesson.dart';
import 'package:flutter/material.dart';

class LessonDetails extends StatefulWidget {
  Lesson lessons; 
  
  LessonDetails({Key key, this.lessons}) : super(key: key);

  @override
  _LessonDetailsState createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  // Variables

  // Methods

  // Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lessons.title),
        backgroundColor: Colors.yellow[900]
      ),
      body:Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Text(announcements.description)
      )
    );
  }
}
