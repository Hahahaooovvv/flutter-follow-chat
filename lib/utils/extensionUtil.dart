import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow/entity/enum/sharedPreferences.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/sqlLiteUtil.dart';

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

// extension ListExtensionUtil on List {

// }

extension MapExtensionUtils on Map {
  String jsonEncode() {
    return json.encode(this);
  }
}

extension StringExtensionUtils on SharePreferencesKeys {
  String toPrivateUserKeys() {
    return this.toString() + "_" + ReduxUtil.store.state.memberInfo?.memberId;
  }
}

extension NumExtensionUtils on num {
  /// 适配宽度
  num setWidth() {
    return ScreenUtil.getInstance().getAdapterSize(this.toDouble()).toDouble();
    // return ScreenUtil().setWidth(this * 2);
  }

  /// 适配高度
  num setHeight() {
    return ScreenUtil.getInstance().getAdapterSize(this.toDouble()).toDouble();
  }

  /// 适配字体
  num setSp() {
    return ScreenUtil.getInstance().getAdapterSize(this.toDouble()).toDouble();
  }

  /// 设置为屏幕宽度的倍数
  num sWidth() {
    return (ScreenUtil.getInstance().screenWidth * this.toDouble()).toDouble();
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

extension DynamicListExtensionUtils<T> on List<T> {
  List<T> deepCopy() {
    List<T> _oldList = this;
    return List<T>.generate(
      _oldList.length,
      (index) => _oldList[index],
      growable: true,
    );
  }

  /// 通过列表获取插入语句
  SqlUtilTransactionTemple getInsertDbTStr({String Function(T) mapIds}) {
    return SqlLiteUtil().getInsertDbTStr<T>(this, mapIds: mapIds);
  }
  
  mergeCondition(List<T> newList, bool Function(T p1, T p2) condition) {
    List<T> _deepList = this.deepCopy();
    List<int>.generate(this.length, (index) => index).forEach((p) {
      var _index = newList.indexWhere((p2) => condition(this[p], p2));
      if (_index > -1) {
        _deepList[p] = newList[_index];
      } else {
        _deepList.add(newList[_index]);
      }
    });
    return _deepList;
  }
}
