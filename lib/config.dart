import 'package:flutter/material.dart';

class Config {
  /// 当前环境
  static EConfigEnvironmental environmental = EConfigEnvironmental.dvevelopment;

  ///
  static String mainApiUrl = "172.16.0.215:5000";
  ConfigApis apiUrlsConfig;
  String appId = "0";
  String pid = "201903120228314";
  String protocol = "http://";
  String wsProtocol = "ws://";

  // 工厂模式
  factory Config() => _getInstance();
  static Config get instance => _getInstance();
  static Config preInstance;
  Config._internal() {
    if (environmental == EConfigEnvironmental.dvevelopment) {
      Config.mainApiUrl = "172.16.0.215:5000";
      apiUrlsConfig = ConfigApis(ws: "$wsProtocol${Config.mainApiUrl}", main: "$protocol${Config.mainApiUrl}");
    } else {
      apiUrlsConfig = ConfigApis(ws: "$wsProtocol${Config.mainApiUrl}/websocket", main: "$protocol${Config.mainApiUrl}");
    }
  }
  static Config _getInstance() {
    if (preInstance == null) {
      preInstance = new Config._internal();
    }
    return preInstance;
  }
}

enum EConfigEnvironmental {
  /// 生产环境
  production,

  /// 开发环境
  dvevelopment,
}

class ConfigApis {
  final String main;
  final String ws;

  ConfigApis({@required this.ws, @required this.main});
}
