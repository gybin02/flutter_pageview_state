import 'dart:developer';

import 'package:flutter/material.dart';

import '../mock.dart';

class PageAutoKeep extends StatefulWidget {
  @override
  _PageAutoKeepState createState() => _PageAutoKeepState();
}

class _PageAutoKeepState extends State<PageAutoKeep> {
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
                      pageController.jumpToPage(value);
                    }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
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

class _PageOneState extends State<PageOne> with AutomaticKeepAliveClientMixin {
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

  @override
  bool get wantKeepAlive => true;
}
