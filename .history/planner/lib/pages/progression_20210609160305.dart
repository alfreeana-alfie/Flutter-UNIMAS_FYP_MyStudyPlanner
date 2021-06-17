import 'package:flutter/material.dart';

class Progression extends StatefulWidget {
  const Progression({Key key}) : super(key: key);

  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progression'),
      ),
      body: buildMainContainer(),
    );
  }

  Widget buildMainContainer() {
    return Container(
      child: Column(
        children: [
          Text('Pie Chart'),
        ],
      ),
    );
  }
}
