import 'package:flutter/material.dart';
import 'package:follow/pages/drawer/homeDrawer.dart';
import 'package:follow/pages/navigation/friends.dart';
import 'package:follow/pages/navigation/message.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/socketUtil.dart';

class BottomNavigationBarPage extends StatefulWidget {
  BottomNavigationBarPage({Key key}) : super(key: key);

  @override
  _BottomNavigationBarPageState createState() => _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ModalUtil.scaffoldkey = this._scaffoldkey;
    // 初始化socket
    CommonUtil.whenRenderEnd((duration) {
      SocketUtil.initSocket(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: HomeDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (_index) {
          this.setState(() {
            _currentIndex = _index;
            _pageController.jumpToPage(_index);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.message), title: Text("消息")),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("联系人")),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [MessagePage(), FrindsPage()],
      ),
    );
  }
}
