import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/imageUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/wiget/widgetAvatar.dart';
import 'package:follow/wiget/widgetInput.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// 性别
  int gender = 1;

  String name = "陈晨";
  String account = "";
  String password = "";
  bool aggress = false;
  String avatar;

  /// 获取默认头像
  String getAvatar() {
    return this.avatar ?? ["http://wechat-demo-zdc.oss-cn-chengdu.aliyuncs.com/male.jpg", "http://wechat-demo-zdc.oss-cn-chengdu.aliyuncs.com/female.jpg"][gender];
  }

  /// 注册
  register() async {
    if (account.length < 4) {
      ModalUtil.toastMessage("请输入正确的账号");
    } else if (password.length < 4) {
      ModalUtil.toastMessage("请输入正确的密码");
    } else if (name.isEmpty) {
      ModalUtil.toastMessage("请输入正确的昵称");
    } else {
      if (await new MemberApi().userRegister(account, password, this.getAvatar(), name, gender)) {
        Navigator.pop(context, account);
      }
    }
  }

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
                WidgetAvatar(url: this.getAvatar(), size: 90).tapExtension(() {
                  new ImageUtil().upLoadAvatar(context).then((value) {
                    if (value != null) {
                      this.setState(() {
                        this.avatar = value;
                      });
                    }
                  });
                }),
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
          WidgetInput(
            inputFormatters: [LengthLimitingTextInputFormatter(8)],
            hintText: "设置昵称（例如：沙雕）",
            prefixIcon: Icon(Icons.sentiment_neutral),
            onChanged: (str) {
              this.setState(() {
                this.name = str;
              });
            },
          ).paddingExtension(16.setPaddingAll()),
          WidgetInput(
            inputFormatters: [LengthLimitingTextInputFormatter(12), WhitelistingTextInputFormatter(RegExp("[A-Za-z0-9]"))],
            hintText: "输入账号",
            prefixIcon: Icon(Icons.perm_identity),
            onChanged: (str) {
              this.setState(() {
                this.account = str;
              });
            },
          ).paddingExtension(EdgeInsets.fromLTRB(16.setWidth(), 0, 16.setWidth(), 16.setHeight())),
          WidgetInput(
            inputFormatters: [LengthLimitingTextInputFormatter(16), WhitelistingTextInputFormatter(RegExp("[A-Za-z0-9\.]"))],
            hintText: "输入密码",
            prefixIcon: Icon(Icons.lock_outline),
            onChanged: (str) {
              this.setState(() {
                this.password = str;
              });
            },
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
              onPressed: this.register,
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
