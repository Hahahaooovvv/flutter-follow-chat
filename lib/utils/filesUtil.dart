import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:follow/utils/requestUtils.dart';

class MessageStreamController {
  final String id;
  final StreamController<double> streamController;
  final File file;

  MessageStreamController(this.id, this.streamController, this.file);
}

class FileUtil {
  /// 上传streamControler
  static List<MessageStreamController> messageStreamControllers = [];

  /// 文件上传
  Future<EntityFileUpload<dynamic>> fileUpload(
    String id, {
    String url: "/api/Member/upload",
    @required String filePath,
    @required int fileType,
  }) async {
    // 上传文件
    return await RequestHelper.fileUpLoad(filePath: filePath, fileType: fileType, url: url).then((value) {
      FileUtil.messageStreamControllers.add(MessageStreamController(id, value.streamController, File(filePath)));
      return value;
    });
  }
}
