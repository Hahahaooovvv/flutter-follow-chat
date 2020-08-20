import 'package:flutter/material.dart';
import 'package:follow/pages/drawer/homeDrawer.dart';
import 'package:follow/pages/navigation/friends.dart';
import 'package:follow/pages/navigation/message.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/socketUtil.dart';

class BottomNavigationBarPage extends StatefulWidget {
  BottomNavigationBarPage({Key key}) : super(key: key);

  @override
  _BottomNavigationBarPageState createState() => _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ModalUtil.scaffoldkey = this._scaffoldkey;
    // socket链接
    new SocketUtil().connect(true);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    new SocketUtil().close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "消息"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "联系人"),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [MessagePage(), FrindsPage()],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
