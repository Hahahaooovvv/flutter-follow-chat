import 'package:cached_network_image/cached_network_image.dart';
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
    String _url = this.url;
    return ClipOval(
      child: Container(
        color: Colors.white,
        padding: this.padding.setPaddingAll(),
        child: ClipOval(
            child: _url == null
                ? Container(
                    width: this.size.setWidth(),
                    height: this.size.setWidth(),
                  )
                : CachedNetworkImage(
                    imageUrl: _url,
                    width: this.size.setWidth(),
                    height: this.size.setWidth(),
                  )),
      ),
    );
  }
}
