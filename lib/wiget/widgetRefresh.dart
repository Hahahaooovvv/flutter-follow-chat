import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

// class WidgetEmptyComponent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           flex: 1,
//           child: Container(),
//         ),
//         WidgetIcon('icon_utils_empty', size: 108),
//         WidgetText("暂无数据", style: TextStyle(color: ColorResources.primaryColorDark)),
//         Expanded(
//           flex: 2,
//           child: Container(),
//         )
//       ],
//     );
//     // );
//   }
// }

class WidgetRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() method;
  final bool empty;
  final bool isScroll;
  final bool firstRefresh;

  const WidgetRefresh({Key key, @required this.child, @required this.method, this.empty: false, this.isScroll: true, this.firstRefresh: false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: BezierHourGlassHeader(
        backgroundColor: Theme.of(context).primaryColor,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      onRefresh: method == null
          ? null
          : () async {
              await this.method();
            },
      firstRefresh: this.firstRefresh,
      // emptyWidget: this.empty ? WidgetEmptyComponent() : null,
      firstRefreshWidget: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        color: Colors.white,
      ),
      child: this.isScroll
          ? SingleChildScrollView(
              child: this.child,
            )
          : this.child,
    );
  }
}
