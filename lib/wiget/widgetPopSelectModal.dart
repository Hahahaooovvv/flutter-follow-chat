import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';

class WidgetPopSelectModalItem<T> {
  final Widget child;
  final String childStr;
  final T value;

  WidgetPopSelectModalItem({this.child, this.childStr, this.value});
}

class WidgetPopSelectModalItemT<T> extends StatelessWidget {
  final WidgetPopSelectModalItem data;

  const WidgetPopSelectModalItemT({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.4))),
      alignment: Alignment.center,
      height: 70,
      child: this.data.child ?? Text(this.data.childStr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
    );
  }
}

class WidgetPopSelectModal<T> extends StatelessWidget {
  final List<WidgetPopSelectModalItem> children;
  final Function(T value) onSelect;
  WidgetPopSelectModal({
    Key key,
    @required this.onSelect,
    @required this.children,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ...children.map((e) {
          return FlatButton(
              onPressed: () {
                Navigator.pop(context);
                this.onSelect(e.value);
              },
              child: WidgetPopSelectModalItemT(data: e));
        }).toList(),
        ...[
          Container(height: 8, color: Theme.of(context).scaffoldBackgroundColor),
          Container(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 0.4))),
            alignment: Alignment.center,
            height: 70,
            child: Text("取消", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
          ).tapExtension(() {
            Navigator.pop(context);
          })
        ]
      ]),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
    );
  }
}
