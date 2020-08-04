import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';

class WidgetAvatar extends StatelessWidget {
  final String url;
  final double padding;
  final double size;

  const WidgetAvatar({
    Key key,
    @required this.url,
    this.size: 80,
    this.padding: 0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String _url = this.url ?? "https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=218375221,1552855610&fm=111&gp=0.jpg";
    return ClipOval(
      child: Container(
        color: Colors.white,
        padding: this.padding.setPaddingAll(),
        child: _url.startsWith("http")
            ? ClipOval(
                child: Image.network(
                _url,
                width: this.size.setWidth(),
                height: this.size.setWidth(),
              ))
            : ClipOval(
                child: Image.asset(
                _url,
                width: this.size.setWidth(),
                height: this.size.setWidth(),
              )),
      ),
    );
  }
}
