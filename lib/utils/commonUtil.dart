import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtil {
  /// 等待组件渲染完成回调
  static whenRenderEnd(Function(Duration duration) func) {
    WidgetsBinding.instance.addPostFrameCallback(func);
  }

  static closeKeyBord(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// 获取持久化储存对象
  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}
