import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';

enum WidgetMessageBubbleDirectionArrowType { left, right }

class WidgetMessageBubble extends StatelessWidget {
  WidgetMessageBubble({
    Key key,
    @required this.child,
    this.width,
    this.height,
    this.direction: WidgetMessageBubbleDirectionArrowType.left,
  }) : super(key: key);
  final Widget child;
  final double width;
  final double height;
  final WidgetMessageBubbleDirectionArrowType direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: CustomPaint(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: child ?? Container(),
          constraints: BoxConstraints(minHeight: 50),
          decoration: BoxDecoration(color: direction == WidgetMessageBubbleDirectionArrowType.left ? Colors.white : Color.fromARGB(255, 169, 232, 122), borderRadius: BorderRadius.circular(6)),
        ).paddingExtension(EdgeInsets.symmetric(horizontal: 10)),
        painter: WidgetMessageBubbleCanvas(this.direction, context),
      ),
    );
  }
}

class WidgetMessageBubbleCanvas extends CustomPainter {
  final WidgetMessageBubbleDirectionArrowType direction;

  WidgetMessageBubbleCanvas(this.direction, this.context);

  final BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..strokeWidth = 1.0 //线宽
      ..color = direction == WidgetMessageBubbleDirectionArrowType.left ? Colors.white : Color.fromARGB(255, 169, 232, 122)
      ..isAntiAlias = true;
    double y = 20;
    Path path = Path();
    if (direction == WidgetMessageBubbleDirectionArrowType.left) {
      path.moveTo(0, 10 + y);
      path.lineTo(10, 15 + y);
      path.lineTo(10, 5 + y);
      path.lineTo(0, 10 + y);
      canvas.drawPath(path, _paint);
    } else {
      path.moveTo(size.width, 10 + y);
      path.lineTo(size.width - 10, 15 + y);
      path.lineTo(size.width - 10, 5 + y);
      path.lineTo(size.width, 10 + y);
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(WidgetMessageBubbleCanvas oldDelegate) {
    return false;
  }
}
