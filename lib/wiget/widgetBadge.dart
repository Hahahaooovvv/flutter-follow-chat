import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';

class WidgetBadge extends StatelessWidget {
  final int noticeCount;

  const WidgetBadge({
    Key key,
    @required this.noticeCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      shape: BadgeShape.square,
      borderRadius: 8,
      padding: [2, 6].setPadding(),
      showBadge: this.noticeCount > 0,
      badgeContent: Text(noticeCount.toString(), style: TextStyle(color: Colors.white, fontSize: 10.setSp())),
    );
  }
}
