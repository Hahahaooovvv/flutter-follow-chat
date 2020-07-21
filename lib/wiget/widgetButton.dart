import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';

enum WidgetButtonType { primary }

class WidgetButton extends FlatButton {
  WidgetButton({
    Widget child,
    Function onPressed,
    bool filled: true,
    BorderRadius radius,
    WidgetButtonType type: WidgetButtonType.primary,
    Color color,
    double width,
  })  : assert(child != null),
        assert(onPressed != null),
        super(
            shape: RoundedRectangleBorder(borderRadius: radius ?? BorderRadius.circular(filled ? 2 : 24)),
            onPressed: onPressed,
            child: filled
                ? Container(
                    width: width,
                    alignment: Alignment.center,
                    height: 36.setHeight(),
                    child: child,
                  )
                : Container(
                    width: width,
                    alignment: Alignment.center,
                    height: 24.setHeight(),
                    child: child,
                  ),
            textColor: Colors.white,
            color: color ?? [Color.fromARGB(255, 100, 142, 247)][type.index]);
}
