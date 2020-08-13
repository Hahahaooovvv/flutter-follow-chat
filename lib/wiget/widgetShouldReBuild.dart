import 'package:flutter/material.dart';

typedef WidgetShouldRebuildFunction<T> = bool Function(T oldWidget, T newWidget);

class WidgetShouldRebuild<T extends Widget> extends StatefulWidget {
  final T child;
  final WidgetShouldRebuildFunction<T> shouldRebuild;
  WidgetShouldRebuild({@required this.child, @required this.shouldRebuild})
      : assert(() {
          if (child == null) {
            throw FlutterError.fromParts(<DiagnosticsNode>[ErrorSummary('ShouldRebuild widget: child must not be  null')]);
          } else if (shouldRebuild == null) {
            throw FlutterError.fromParts(<DiagnosticsNode>[ErrorSummary('ShouldRebuild widget: shouldRebuild must not be  null')]);
          }
          return true;
        }());
  @override
  _ShouldRebuildState createState() => _ShouldRebuildState<T>();
}

class _ShouldRebuildState<T extends Widget> extends State<WidgetShouldRebuild> {
  @override
  WidgetShouldRebuild<T> get widget => super.widget;
  T oldWidget;
  @override
  Widget build(BuildContext context) {
    final T newWidget = widget.child;
    if (this.oldWidget == null || (widget.shouldRebuild == null ? true : widget.shouldRebuild(oldWidget, newWidget))) {
      this.oldWidget = newWidget;
    }
    return oldWidget;
  }
}
