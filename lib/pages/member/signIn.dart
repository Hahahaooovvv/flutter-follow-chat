import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow/helper/memberHelper.dart';
import 'package:follow/pages/member/signUp.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/wiget/widgetButton.dart';
import 'package:follow/wiget/widgetInput.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _accoundController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  void userLogin() {
    // 用户登录
    String accound = _accoundController.text;
    String password = _passwordController.text;
    MemberHelper().login(context, accound, password);
  }

  @override
  void initState() {
    super.initState();
    // 判断是否已经登录了
    CommonUtil().initSystem(context);
    // MemberHelper memberHelper = new MemberHelper();
    // memberHelper.getMemberInfoFromLocal().then((value) {
    //   if (value != null) {
    //     memberHelper.cacheMemberInfoToRedux(value);
    //     RouterUtil.replace(context, BottomNavigationBarPage());
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Image.network("http://tangdaben.oss-cn-shanghai.aliyuncs.com/image.png", fit: BoxFit.fill, height: 1.sWidth(), width: 1.sWidth()),
            WidgetInput(
              inputFormatters: [LengthLimitingTextInputFormatter(12), WhitelistingTextInputFormatter(RegExp("[A-Za-z0-9]"))],
              prefixIcon: Icon(Icons.perm_identity),
              controller: _accoundController,
              hintText: "请输入账号",
            ).paddingExtension(16.setPaddingAll()),
            WidgetInput(
              obscureText: true,
              inputFormatters: [LengthLimitingTextInputFormatter(16), WhitelistingTextInputFormatter(RegExp("[A-Za-z0-9\.]"))],
              prefixIcon: Icon(Icons.lock_outline),
              controller: _passwordController,
              hintText: "请输入密码",
            ).paddingExtension(EdgeInsets.fromLTRB(16.setWidth(), 0, 16.setWidth(), 16.setHeight())),
            WidgetButton(
              child: Text("登录"),
              onPressed: this.userLogin,
            ).paddingExtension(EdgeInsets.symmetric(horizontal: 16.setWidth())),
            Container(
              padding: EdgeInsets.only(bottom: max(MediaQuery.of(context).padding.bottom, 8.setHeight())),
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                  onPressed: () {
                    RouterUtil.push(context, SignUpPage()).then((value) {
                      if (value != null) {
                        this._accoundController.text = value;
                      }
                    });
                  },
                  child: Text("注册账号?", style: TextStyle(color: Color.fromARGB(255, 100, 142, 247), fontSize: 14.setSp(), fontWeight: FontWeight.bold))),
            ).flexExtension()
          ],
        ),
      ),
    );
  }
}
