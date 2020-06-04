import 'dart:developer';

import 'package:flutter/material.dart';
import '../mock.dart';

class PageDefault extends StatefulWidget {
  @override
  _PageDefaultState createState() => _PageDefaultState();
}

class _PageDefaultState extends State<PageDefault> {
  PageController pageController;

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
          title: Text('PageView 默认行为'),
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
                      pageController.jumpToPage(value);
                    }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: <Widget>[
                  PageOne(title: "One",),
                  PageOne(title: "two",),
                ],
              ),
            ),
          ],
        ));
  }
}

class PageOne extends StatefulWidget {
  final String title;

  PageOne({Key key, this.title}) : super(key: key);

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  var dataList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      dataList.add(" ${widget.title} : line  $i");
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
