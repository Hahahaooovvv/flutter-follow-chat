# follow

仅作为学习使用的一款聊天交友 APP。

> 项目介绍

前端使用 Flutter 构建，后端使用 netcore，（因本人后端技术实在太垃圾，后端选择不开源 QAQ），使用 websocket 交互，未使用三方 IM，前台缓使`sqllite`缓存聊天信息。  
本项目刚开始启动，作为一个从 0 开始的项目，我还有很多设想，会在职业生涯中慢慢完善。

> 软件相册

<div style="display:flex" >
    <img src="https://github.com/ZhangDengchuan/flutter-follow-chat/blob/dev_zhangdengchuan/assets/cover.gif?raw=true" />
<img src="https://github.com/ZhangDengchuan/flutter-follow-chat/blob/dev_zhangdengchuan/assets/friend.gif?raw=true" />
<img src="https://github.com/ZhangDengchuan/flutter-follow-chat/blob/dev_zhangdengchuan/assets/read.gif?raw=true" />
</div>

> 更新日志

- v 1.0.1 (项目发布，基础聊天、更换头像、添加好友等)

> 下版本预计目标

- [x] 发送图片
- [x] 点击之后滑动预览发送的图片
- [x] 当 websocket 断开 发送消息失败时候有一个小红色的图标点击可从新发送
- [ ] 发送视频
- [ ] 发送语音聊天
- [x] 处理 websocket 心跳检测 (切换 SignlaR)

> 体验

android 下载地址：http://wechat-demo-zdc.oss-cn-chengdu.aliyuncs.com/app/release/follow-1-0-1.apk

二维码：![下载地址](https://github.com/ZhangDengchuan/flutter-follow-chat/blob/dev_zhangdengchuan/assets/v-1-0-1.png?raw=true)

> 交流群

QQ 群: 879108483

> flutter 环境

```
[✓] Flutter (Channel master, 1.21.0-6.0.pre.40, on Mac OS X 10.15.1 19B2106, locale zh-Hans-CN)
    • Flutter version 1.21.0-6.0.pre.40 at /Users/zhangdengchuan/Documents/SDK/flutter
    • Framework revision d834673033 (7 天前), 2020-07-27 17:51:31 -0700
    • Engine revision f27729e97b
    • Dart version 2.10.0 (build 2.10.0-0.0.dev 24c7666def)
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn

[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
    • Android SDK at /Users/zhangdengchuan/Library/Android/sdk
    • Platform android-29, build-tools 29.0.2
    • ANDROID_HOME = /Users/zhangdengchuan/Library/Android/sdk
    • Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_202-release-1483-b49-5587405)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 11.3)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 11.3, Build version 11C29
    • CocoaPods version 1.9.1

[!] Android Studio (version 3.5)
    • Android Studio at /Applications/Android Studio.app/Contents
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
    • Java version OpenJDK Runtime Environment (build 1.8.0_202-release-1483-b49-5587405)

[✓] VS Code (version 1.47.3)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.13.1

[✓] Connected device (1 available)
    • iPhone 11 (mobile) • 18D5028D-C919-4407-9D3F-5AEDFACE22BF • ios • com.apple.CoreSimulator.SimRuntime.iOS-13-3 (simulator)

! Doctor found issues in 1 category.
```
