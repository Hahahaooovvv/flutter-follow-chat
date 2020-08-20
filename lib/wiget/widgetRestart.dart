import 'package:flutter/material.dart';

class WidgetRestart extends StatefulWidget {
  WidgetRestart({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    //查找顶层_WidgetRestartState并重启
    context.findAncestorStateOfType<_WidgetRestartState>().restartApp();
  }

  @override
  _WidgetRestartState createState() => _WidgetRestartState();
}

class _WidgetRestartState extends State<WidgetRestart> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey(); //重新生成key导致控件重新build
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
