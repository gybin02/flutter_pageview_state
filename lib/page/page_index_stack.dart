import 'dart:developer';

import 'package:flutter/material.dart';

import '../mock.dart';

class PageIndexStatck extends StatefulWidget {
  @override
  _PageIndexStatckState createState() => _PageIndexStatckState();
}

class _PageIndexStatckState extends State<PageIndexStatck> {
  PageController pageController;

  int position = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('appbarTitle'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.green,
              child: DefaultTabController(
                length: myTabs.length,
                child: TabBar(
                    tabs: myTabs,
                    onTap: (value) {
                      log("jumpToPage: $value");
                      this.position = value;
                      setState(() {});
//                      pageController.jumpToPage(value);
                    }),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: position,
                children: <Widget>[
                  PageOne(),
                  PageOne(),
                ],
              ),
            ),
          ],
        ));
  }
}

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  var dataList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      dataList.add("title $i");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        title: Text(dataList[index]),
      );
    });
  }
}
