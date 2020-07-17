import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/wiget/widgetAvatar.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// 性别
  int gender = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                WidgetAvatar(url: null, size: 90),
                Container(
                  width: 90.setWidth(),
                  height: 110.setWidth(),
                  alignment: Alignment.bottomCenter,
                  child: ClipOval(
                    child: Container(
                      width: 34.setWidth(),
                      height: 34.setWidth(),
                      color: Colors.white,
                      child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                fillColor: Color.fromARGB(255, 245, 248, 249),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(4),
                ),
                prefixIcon: Icon(Icons.perm_identity),
                hintText: "输入账号",
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
                hintText: "输入密码",
                filled: true),
          ).paddingExtension(EdgeInsets.fromLTRB(16.setWidth(), 0, 16.setWidth(), 16.setHeight())),
          Row(
            children: List<Widget>.generate(2, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Container(
                      width: 40.setWidth(),
                      height: 40.setWidth(),
                      color: this.gender == index ? Theme.of(context).primaryColor : Color.fromARGB(255, 245, 248, 249),
                      child: Image.asset(
                        ["lib/icons/icon_user_male.png", "lib/icons/icon_user_female.png"][index],
                        width: 18.setWidth(),
                        height: 18.setWidth(),
                        fit: BoxFit.fill,
                        color: this.gender == index ? Colors.white : null,
                      ).centerExtension(),
                    ),
                  ),
                  Text(["男", "女"][index]).paddingExtension(EdgeInsets.only(left: 16.setWidth()))
                ],
              ).tapExtension(() {
                this.setState(() {
                  gender = index;
                });
              }).paddingExtension(EdgeInsets.only(right: 32.setWidth()));
            }),
          ).paddingExtension(16.setPaddingHorizontal()),
          Row(
            children: [
              Checkbox(value: true, onChanged: (_value) {}),
              Text.rich(
                TextSpan(
                  text: "同意",
                  style: TextStyle(color: Color(0XFF889399), fontSize: 12.setSp()),
                  children: [TextSpan(text: "《用户协议》", style: TextStyle(color: Theme.of(context).primaryColor))],
                ),
              )
            ],
          ).paddingExtension(EdgeInsets.only(top: 16.setHeight(), bottom: 16.setHeight(), left: 8.setWidth())),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              onPressed: () {},
              child: Container(
                alignment: Alignment.center,
                height: 36.setHeight(),
                child: Text("注册"),
              ),
              textColor: Colors.white,
              color: Color.fromARGB(255, 100, 142, 247),
            ).paddingExtension(16.setPaddingHorizontal()),
          )
        ],
      ),
    );
  }
}
