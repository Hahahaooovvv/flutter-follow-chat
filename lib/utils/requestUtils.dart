import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:follow/config.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/utils/imageUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/reduxUtil.dart';

class EntityFileUpload<T> {
  final StreamController<double> streamController;
  final Future<Response<EntityResponse<dynamic>>> response;

  EntityFileUpload({
    @required this.streamController,
    @required this.response,
  });
}

class EntityResponse<T> {
  int code;
  String message;
  T data;
  bool success;

  EntityResponse({this.code, this.message, this.data, this.success});

  EntityResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? json['Code'];
    message = json['message'] ?? json['Message'];
    data = json['data'] ?? json['Data'];
    success = json['success'] ?? json['Success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    data['success'] = this.success;
    return data;
  }
}

enum RequestMethod {
  POST,
  GET,
  PUT,
  DELETE,
}

class RequestHelper {
  // 请求实例
  static Dio instance;

  // 初始化请求实例
  static void initInstance() {
    RequestHelper.instance = new Dio();
    RequestHelper.instance.interceptors.add(InterceptorsWrapper(onRequest: (options) async {
      options.headers["platform"] = Platform.isAndroid ? 0 : 1;
      options.headers["access-token"] = ReduxUtil.store.state.memberInfo?.token;
      options.contentType = Headers.formUrlEncodedContentType;
      options.responseType = ResponseType.json;
      options.baseUrl = Config.instance.apiUrlsConfig.main;
      return options;
    }, onResponse: (option) async {
      if (option.statusCode == HttpStatus.ok) {
        option.data = EntityResponse.fromJson(option.data);
      } else {
        option.data = EntityResponse(code: 500, data: null, success: false, message: "网络链接缓慢");
      }
      return option;
    }));
  }

  /// 文件上传
  static Future<EntityFileUpload> fileUpLoad(
      {String url: "/api/Member/upload",
      @required String filePath,
      // @required MultipartFile mltipartFile,
      @required int fileType,
      EntityChatMessageExtend extend}) async {
    Size _size = Size(0, 0);
    int duration = 0;
    if (fileType == 1) {
      // 图片
      _size = await ImageUtil().getImageSize(File(filePath));
    } else if (fileType == 2) {
      duration = extend.duration;
      // AudioPlayer audioPlayer = AudioPlayer();
      // await audioPlayer.setUrl(filePath, isLocal: audioPlayer.isLocalUrl(filePath));
      // duration = await audioPlayer.getDuration();
      // print('-----------');
      // print(duration);
    }
    var _formData = FormData.fromMap({
      "fileType": fileType,
      "files": MultipartFile.fromFileSync(filePath),
      "width": _size.width,
      "height": _size.height,
      "duration": duration,
    });

    StreamController<double> streamController = new StreamController<double>.broadcast();
    Completer<EntityFileUpload<dynamic>> uploadCompleter = Completer();
    Completer<Response<EntityResponse<dynamic>>> completer = Completer();
    uploadCompleter.complete(EntityFileUpload(
      streamController: streamController,
      response: completer.future,
    ));
    RequestHelper.instance.post<EntityResponse>(
      url,
      data: _formData,
      onSendProgress: (_send, _total) {
        streamController.add(_send / _total);
      },
    ).then((value) {
      completer.complete(value);
      return value;
    }).catchError((e) {
      completer.completeError(e);
    }).whenComplete(streamController.close);
    return uploadCompleter.future;
  }

  /// get请求
  static Future<Response<EntityResponse>> request(
    String url,
    RequestMethod method, {

    /// 参数
    Map<String, dynamic> data,

    /// 是否展示Loading
    bool showLoading = false,

    /// 错误时弹出提示
    bool errorTips = false,

    /// 正确或错误时都弹出提示
    bool tips = false,

    /// 正确时弹出提示
    bool successTips = false,
  }) {
    // 展示Loading
    if (showLoading) {
      ModalUtil.showLoading();
    }
    Future<Response<EntityResponse>> response;
    switch (method) {
      case RequestMethod.GET:
        response = RequestHelper.instance.get(url, queryParameters: data);
        break;
      case RequestMethod.DELETE:
        response = RequestHelper.instance.delete(url, queryParameters: data);
        break;
      case RequestMethod.PUT:
        response = RequestHelper.instance.put(url, data: data);
        break;
      case RequestMethod.POST:
        response = RequestHelper.instance.post(url, data: data);
        break;
    }
    Completer<Response<EntityResponse<dynamic>>> completer = Completer();
    response.then((value) {
      if (showLoading) {
        ModalUtil.dismissLoading();
      }
      if (value.data.success) {
        // 请求成功
        if (successTips || tips) {
          ModalUtil.toastMessage(value.data.message);
        }
      } else {
        if (errorTips || tips) {
          ModalUtil.toastMessage(value.data.message);
        }
      }
      completer.complete(value);
      return value;
    }).catchError((e) {
      ModalUtil.dismissLoading();
      ModalUtil.toastMessage("网络链接缓慢");
      completer.completeError(e);
    });
    return completer.future;
  }
}
