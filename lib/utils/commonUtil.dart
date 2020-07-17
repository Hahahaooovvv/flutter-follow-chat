import 'package:flutter/material.dart';

class CommonUtil {
  /// 等待组件渲染完成回调
  static whenRenderEnd(Function(Duration duration) func) {
    WidgetsBinding.instance.addPostFrameCallback(func);
  }

  static closeKeyBord(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
