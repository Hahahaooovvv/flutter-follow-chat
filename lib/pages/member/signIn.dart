import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow/bottomNavigationBar.dart';
import 'package:follow/pages/member/signUp.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Image.network("http://tangdaben.oss-cn-shanghai.aliyuncs.com/image.png", fit: BoxFit.fill, height: 1.sWidth(), width: 1.sWidth()),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Color.fromARGB(255, 245, 248, 249),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  prefixIcon: Icon(Icons.perm_identity),
                  hintText: "请输入账号",
                  filled: true),
            ).paddingExtension(16.setPaddingAll()),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Color.fromARGB(255, 245, 248, 249),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: "请输入密码",
                  filled: true),
            ).paddingExtension(EdgeInsets.fromLTRB(16.setWidth(), 0, 16.setWidth(), 16.setHeight())),
            FlatButton(
              onPressed: () {
                RouterUtil.replace(context, BottomNavigationBarPage());
              },
              child: Container(
                alignment: Alignment.center,
                height: 36.setHeight(),
                child: Text("登录"),
              ),
              textColor: Colors.white,
              color: Color.fromARGB(255, 100, 142, 247),
            ).paddingExtension(EdgeInsets.symmetric(horizontal: 16.setWidth())),
            Container(
              padding: EdgeInsets.only(bottom: max(MediaQuery.of(context).padding.bottom, 8.setHeight())),
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                  onPressed: () {
                    RouterUtil.push(context, SignUpPage());
                  },
                  child: Text("注册账号?", style: TextStyle(color: Color.fromARGB(255, 100, 142, 247), fontSize: 14.setSp(), fontWeight: FontWeight.bold))),
            ).flexExtension()
          ],
        ),
      ),
    );
  }
}
