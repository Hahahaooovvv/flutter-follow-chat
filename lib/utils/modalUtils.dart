import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:follow/wiget/widgetPopSelectModal.dart';

class ModalUtil {
  /// 底部弹出选择栏
  static showPopSelect<T>(
    BuildContext context, {
    @required List<WidgetPopSelectModalItem> children,
    @required void Function(T value) onSelect,
  }) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return WidgetPopSelectModal<T>(
            onSelect: onSelect,
            children: children,
          );
        });
  }

  static GlobalKey<ScaffoldState> scaffoldkey;

  static openDrawer() {
    ModalUtil.scaffoldkey.currentState.openDrawer();
  }

  static closeDrawer() {
    ModalUtil.scaffoldkey.currentState.openEndDrawer();
  }

  static showRule(
    BuildContext context, {
    Function() onpressed,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onpressed();
                  },
                  child: Text("我同意"))
            ],
            content: Text("-本Demo软件仅作为学习使用，无任何商业用途。\r\n-请勿用作其他使用，本demo代码已开源，请保护自己的个人信息。\r\n-如有使用代码需求请联系作者（登录后会有作者好友）"),
          );
        });
  }

  static showLoading() {
    EasyLoading.show();
  }

  static dismissLoading() {
    EasyLoading.dismiss();
  }

  /// 吐司
  static toastMessage(String message, {Duration duration}) {
    duration = Duration(milliseconds: 1500);
    EasyLoading.showToast(message, duration: duration);
  }
}
