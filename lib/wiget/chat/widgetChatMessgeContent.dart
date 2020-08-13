import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:lottie/lottie.dart';

/// 图片访问
class WidgetChatImage extends StatefulWidget {
  WidgetChatImage({
    Key key,
    @required this.file,
    @required this.msg,
    @required this.height,
  }) : super(key: key);
  final File file;
  final String msg;
  final double height;

  @override
  _WidgetChatImageState createState() => _WidgetChatImageState();
}

class _WidgetChatImageState extends State<WidgetChatImage> with AutomaticKeepAliveClientMixin {
  File _file;

  @override
  void initState() {
    super.initState();
    this._file = this.widget.file;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: (this._file == null
          ? CachedNetworkImage(imageUrl: this.widget.msg, width: 200, height: this.widget.height) //.tapExtension(this.widget.onImagePress)
          : Image.memory(
              this._file.readAsBytesSync(),
              width: 200,
              height: this.widget.height,
            )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// 语音
class WidgetChatMessageSound extends StatefulWidget {
  WidgetChatMessageSound({Key key, @required this.sound}) : super(key: key);
  @override
  _WidgetChatMessageSoundState createState() => _WidgetChatMessageSoundState();
  final String sound;
}

class _WidgetChatMessageSoundState extends State<WidgetChatMessageSound> with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription streamSubscription;
  bool animate = false;

  togale() {
    this.setState(() {
      animate = true;
    });
    audioPlayer.play(this.widget.sound, isLocal: audioPlayer.isLocalUrl(this.widget.sound));
    streamSubscription = audioPlayer.onPlayerCompletion.listen((event) {
      this.setState(() {
        animate = false;
      });
      streamSubscription.cancel();
      streamSubscription = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'lib/assets/lottie/sound.json',
      height: 50,
      animate: animate,
    ).tapExtension(() {
      this.togale();
    });
  }
}
