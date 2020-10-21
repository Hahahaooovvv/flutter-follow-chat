import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/helper/memberHelper.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/imageUtil.dart';

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
            child: CachedNetworkImage(
          imageUrl: _url,
          width: this.size.setWidth(),
          height: this.size.setWidth(),
        )),
      ),
    );
  }
}

class WidgetAvatarSetting extends StatelessWidget {
  final String url;
  final bool canSetting;
  final Function(String url) settingFunc;

  const WidgetAvatarSetting({
    Key key,
    @required this.url,
    this.canSetting,
    this.settingFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WidgetAvatar(url: url, size: 90).tapExtension(this.settingFunc ??
            () {
              new ImageUtil().uploadImg(context, clip: true).then((value) async {
                if (value != null) {
                  await MemberApi().settingAvatar(value);
                  MemberHelper().updateMemberInfo();
                }
              });
            }),
        Container(
          width: 90.setWidth(),
          height: 110.setWidth(),
          alignment: Alignment.bottomCenter,
          child: ClipOval(
            child: Container(
              width: 34.setWidth(),
              height: 34.setWidth(),
              color: Colors.white,
              child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
            ),
          ),
        )
      ],
    );
  }
}
