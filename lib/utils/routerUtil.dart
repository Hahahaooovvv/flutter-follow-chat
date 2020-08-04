import 'package:flutter/material.dart';

enum RouterAnimationType { fade, slide, slideUp }

class RouterUtil extends PageRouteBuilder {
  /// 进入一个页面
  static Future push(BuildContext context, Widget widget, [RouterAnimationType type]) {
    return Navigator.of(context).push(RouterUtil(widget, type: type));
  }

  /// 进入一个页面
  static replace(BuildContext context, Widget widget, [RouterAnimationType type]) {
    Navigator.of(context).pushReplacement(RouterUtil(widget, type: type));
  }

  static Future pushAndRemoveUntil(BuildContext context, Widget widget, [RouterAnimationType type]) {
    return Navigator.of(context).pushAndRemoveUntil(RouterUtil(widget, type: type), (route) => route == null);
  }

  final Widget widget;

  @override
  Color get barrierColor => Colors.black54;

  RouterUtil(this.widget, {RouterAnimationType type: RouterAnimationType.slide})
      : super(
            // 设置过度时间
            transitionDuration: Duration(milliseconds: 300),
            // 构造器
            pageBuilder: (
              // 上下文和动画
              BuildContext context,
              Animation<double> animaton1,
              Animation<double> animaton2,
            ) {
              return widget;
            },
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animaton1,
              Animation<double> animaton2,
              Widget child,
            ) {
              switch (type) {
                case RouterAnimationType.slide:
                  // 左右滑动动画效果
                  return SlideTransition(
                    position: Tween<Offset>(
                            // 设置滑动的 X , Y 轴
                            begin: Offset(1.0, 0.0),
                            end: Offset(0.0, 0.0))
                        .animate(CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
                    child: child,
                  );
                case RouterAnimationType.slideUp:
                  // 向上滑动动画效果
                  return SlideTransition(
                    position: Tween<Offset>(
                            // 设置滑动的 X , Y 轴
                            begin: Offset(0.0, 1.0),
                            end: Offset(0.0, 0.0))
                        .animate(CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
                    child: child,
                  );
                case RouterAnimationType.fade:
                  // 左右滑动动画效果
                  return FadeTransition(
                    // 从0开始到1
                    opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      // 传入设置的动画
                      parent: animaton1,
                      // 设置效果，快进漫出   这里有很多内置的效果
                      curve: Curves.fastOutSlowIn,
                    )),
                    child: child,
                  );
                default:
                  return SlideTransition(
                    position: Tween<Offset>(
                            // 设置滑动的 X , Y 轴
                            begin: Offset(1.0, 0.0),
                            end: Offset(0.0, 0.0))
                        .animate(CurvedAnimation(parent: animaton1, curve: Curves.fastOutSlowIn)),
                    child: child,
                  );
              }

              // 需要什么效果把注释打开就行了
              // 渐变效果
              // return FadeTransition(
              //   // 从0开始到1
              //   opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              //     // 传入设置的动画
              //     parent: animaton1,
              //     // 设置效果，快进漫出   这里有很多内置的效果
              //     curve: Curves.fastOutSlowIn,
              //   )),
              //   child: child,
              // );

              // 缩放动画效果
              // return ScaleTransition(
              //   scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
              //     parent: animaton1,
              //     curve: Curves.fastOutSlowIn
              //   )),
              //   child: child,
              // );

              // 旋转加缩放动画效果
              // return RotationTransition(
              //   turns: Tween(begin: 0.0,end: 1.0)
              //   .animate(CurvedAnimation(
              //     parent: animaton1,
              //     curve: Curves.fastOutSlowIn,
              //   )),
              //   child: ScaleTransition(
              //     scale: Tween(begin: 0.0,end: 1.0)
              //     .animate(CurvedAnimation(
              //       parent: animaton1,
              //       curve: Curves.fastOutSlowIn
              //     )),
              //     child: child,
              //   ),
              // );
            });
}

class CustomerPopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  CustomerPopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
