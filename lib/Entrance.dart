import 'dart:math';
import 'package:flutter/material.dart';
import 'package:follow/pages/member/signIn.dart';
import 'package:follow/pages/member/signUp.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';

class EntrancePage extends StatefulWidget {
  EntrancePage({Key key}) : super(key: key);

  @override
  _EntrancePage createState() => _EntrancePage();
}

class _EntrancePage extends State<EntrancePage> {
  double backOpacity = 0.0;
  _changeOpacity() {
    setState(() => backOpacity = backOpacity == 0 ? 1.0 : 0.0);
  }

  double btnOpacity = 0.0;
  _changebtnOpacity() {
    setState(() => btnOpacity = btnOpacity == 0 ? 1.0 : 0.0);
  }

  @override
  void initState() {
    super.initState();
    CommonUtil.whenRenderEnd((duration) {
      this._changeOpacity();
    });
    Future.delayed(Duration(milliseconds: 1500), () async {
      // 判断是否已经登录了
      if (!await CommonUtil().initSystem(context)) {
        // 如果有用户登录
        this._changebtnOpacity();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0XFF060409),
        brightness: Brightness.dark,
      ),
      backgroundColor:Color(0XFF060409),
      body: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: this.backOpacity,
            duration: new Duration(milliseconds: 300),
            child: Center(
              child: Image.asset("lib/icons/flash.jpeg"),
            ),
          ),
          AnimatedOpacity(
            opacity: this.btnOpacity,
            duration: new Duration(milliseconds: 300),
            child: Center(
                child: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, max(MediaQuery.of(context).padding.bottom, 16)),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 140,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "登录",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ).tapExtension(() {
                    RouterUtil.push(context, SignInPage());
                  }),
                  Container(
                    width: 140,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "注册",
                      style: TextStyle(fontSize: 18),
                    ),
                  ).tapExtension(() {
                    RouterUtil.push(context, SignUpPage());
                  })
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
