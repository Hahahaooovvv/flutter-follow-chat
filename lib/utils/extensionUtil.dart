import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:follow/utils/commonUtil.dart';

extension WidgetExtensionUtil on Widget {
  Widget paddingExtension(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  Widget containerExtension({EdgeInsets padding, EdgeInsets margin, Color color, double height, double width}) {
    return Container(
      child: this,
      margin: margin,
      color: color,
      height: height,
      width: width,
      padding: padding,
    );
  }

  Widget annotatedRegionExtension([SystemUiOverlayStyle value]) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: value ?? SystemUiOverlayStyle.dark,
      child: this,
    );
  }

  Widget alignExtension(Alignment alignment) {
    return Align(alignment: alignment, child: this);
  }

  Widget sizeExtension({double width, double height, double size}) {
    return SizedBox(
      width: size ?? width,
      height: size ?? height,
      child: this,
    );
  }

  Widget clipOvalExtension() {
    return ClipOval(
      child: this,
    );
  }

  Widget inkWellExtension(Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: this,
    );
  }

  Widget tapExtension(Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }

  Widget safeAreaExtension() {
    return SafeArea(child: this);
  }

  Widget flexExtension([int flex = 1]) {
    return Expanded(
      child: this,
      flex: flex,
    );
  }

  Widget centerExtension() {
    return Center(
      child: this,
    );
  }

  Widget keyBoardStatusExtension(context) {
    return GestureDetector(
      onTap: () {
        CommonUtil.closeKeyBord(context);
      },
      child: this,
    );
  }
}

extension ListExtensionUtil on List {
  List<T> deepCopy<T>() {
    List<T> _oldList = this;
    return List<T>.generate(
      _oldList.length,
      (index) => _oldList[index],
      growable: true,
    );
  }
}

extension NumExtensionUtils on num {
  /// 适配宽度
  num setWidth() {
    return ScreenUtil().setWidth(this * 2);
  }

  /// 适配高度
  num setHeight() {
    return ScreenUtil().setHeight(this * 2);
  }

  /// 适配字体
  num setSp() {
    return ScreenUtil().setSp(this * 2, allowFontScalingSelf: false);
  }

  /// 设置为屏幕宽度的倍数
  num sWidth() {
    return ScreenUtil.screenWidth * this;
  }

  EdgeInsets setPaddingAll() {
    return EdgeInsets.symmetric(horizontal: this.setWidth(), vertical: this.setHeight());
  }

  EdgeInsets setPaddingHorizontal() {
    return EdgeInsets.symmetric(horizontal: this.setWidth());
  }

  EdgeInsets setPaddingVertical() {
    return EdgeInsets.symmetric(vertical: this.setWidth());
  }
}

extension NumListExtensionUtils on List<num> {
  EdgeInsets setPadding() {
    return EdgeInsets.symmetric(vertical: this[0].setHeight() ?? 0, horizontal: this[1].setWidth() ?? 0);
  }
}
