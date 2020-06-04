import 'package:flutter/material.dart';

var myTabs = [
  Tab(
    text: "first",
    icon: Icon(Icons.clear),
  ),
  Tab(
    text: "second",
    icon: Icon(Icons.print),
  ),
];

RaisedButton buildRaisedButton(
    BuildContext context, String name, Widget page) {
  return RaisedButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return page;
      }));
    },
    child: Text(name),
  );
}

