import 'dart:developer';

import 'package:flutter/material.dart';

import '../mock.dart';

class PagePageStorageKey extends StatefulWidget {
  @override
  _PagePageStorageKeyState createState() => _PagePageStorageKeyState();
}

class _PagePageStorageKeyState extends State<PagePageStorageKey> {
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PageView 使用 PageStorageKey 保存状态'),
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
                  PageOne(
                    key: PageStorageKey<String>("one"),
                    title: "page one",
                  ),
                  Center(
                    child: Text("Page Two"),
                  )
                  //这里不能再使用PageOne了，因为两个是同一个state
//                  PageOne(
//                    key: PageStorageKey<String>("two"),
//                    title: "page two",
//                  ),
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
    //切换页面，会重新执行
    log("initState");
    for (int i = 0; i < 100; i++) {
      dataList.add("title $i");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log("didChangeDependencies");
  }

  @override
  void didUpdateWidget(PageOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    log("disUpdateWIdget ");
  }

  @override
  void dispose() {
    super.dispose();
    log("dispose");
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
