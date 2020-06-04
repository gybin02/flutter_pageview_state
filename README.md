#  Flutter PageView/TabBarView等控件保存状态的问题解决方案
## 背景

PageView + BottomNavigationBar 或者 TabBarView + TabBar 的时候大家会发现当切换到另一页面的时候, 前一个页面就会被销毁, 再返回前一页时, 页面会被重建, 随之数据会重新加载, 控件会重新渲染 带来了极不好的用户体验， 跟原生的Pager 显示的效果不太一样。

## 解决
### 1. 官方推荐：AutomaticKeepAliveClientMixin

由于TabBarView内部也是用的是PageView, 因此两者的解决方式相同. 下面以PageView为例

```dart
//关键是继承 AutomaticKeepAliveClientMixin
class _Test6PageState extends State<Test6Page> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    print('initState');
  }
 
  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.data.map((n) {
        return ListTile(
          title: Text("第${widget.pageIndex}页的第$n个条目"),
        );
      }).toList(),
    );
  }
 
 //方法返回true
  @override
  bool get wantKeepAlive => true;

```

这样使用这个页面作为 pagerView的child的时候回自动保存状态


### 2. 替换PageView 使用 IndexedStack
IndexedStack 继承 至 Stack，可以根据indexed来决定显示哪个child

```dart
 IndexedStack(
  index: currentIndex,
  children: bodyList,
 ));
```
缺点是：
- 第一次加载时便实例化了所有的子页面State，因此比较适合固定页面的布局
- 无法像pagerView一样通过手势左右滑动

### 3. 不推荐： 使用 Offstage/Visible + stack 手动切换显示。

这个其实就是 indexedstack内部的实现方式，顺便列下。

```dart
Stack(
   children: [
   Offstage(
    offstage: currentIndex != 0,
    child: bodyList[0],
   ),
   Offstage(
    offstage: currentIndex != 1,
    child: bodyList[1],
   ),
   Offstage(
    offstage: currentIndex != 2,
    child: bodyList[2],
   ),
   )
```

### 4. 使用PageStorage在页面切换时保存状态
有点像 Android里面的 saveInstanceState. 自己手动保存数据，手动恢复数据

4.1 创建widget时指定key
```dart
class MyApp extends StatelessWidget {
  final List<TabInfo> _tabs = [
    TabInfo(
      "FIRST", 
      Page1(key: PageStorageKey<String>("key_Page1")) // 指定key
    ), 
    TabInfo("SECOND", Page2()),
    TabInfo("THIRD", Page3()),
  ];
```

4.2 保存state
```dart
IconButton(
                icon: Icon(Icons.remove, size: 32.0),
                onPressed: () {
                  setState(() {
                    _params.counter1--;
                  });
                  PageStorage.of(context).writeState(context, _params);
                },

```

4.3 读取state

重写didChangeDependencies，通过readState 恢复state
```
class _Page1State extends State<Page1> {
  Page1Params _params;

  @override
  void didChangeDependencies() { //重写此方法
    Page1Params p = PageStorage.of(context).readState(context);
    if (p != null) {
      _params = p;
    } else {
      _params = Page1Params();
    }
    super.didChangeDependencies();
  }
```

通过 PageStorage 这种方式重新进入页面，页面其实是重新开始build，但是会根据 didChangeDependencies 里面的数据来初始化

## 思考：

为什么Flutter提供的PagerView 默认不实现 保存状态，而要通过 AutomaticKeepAliveClientMixin 这类来处理呢？ 

## 参考：
- [Flutter: PageView/TabBarView等控件保存状态的问题解决方案 | 掘金技术征文](https://blog.csdn.net/weixin_33980459/article/details/87995111)
- [Flutter实现页面切换后保持原页面状态的3种方法](https://www.jb51.net/article/157680.htm)
- [使用PageStorage在页面切换时保存状态](https://blog.csdn.net/vitaviva/article/details/105313672)
- [flutter TabBarView和PageView的页面状态保存问题 - PageStorageKey|AutomaticKeepAliveClientMixin](https://blog.csdn.net/zhumj_zhumj/article/details/102700305)
