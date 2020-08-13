import 'package:flutter/material.dart';
import 'package:follow/apis/friendApis.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/helper/memberHelper.dart';
import 'package:follow/pages/friend/addFriends.dart';
import 'package:follow/utils/chatMessageUtil.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/imageUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/utils/socketUtil.dart';
import 'package:follow/wiget/widgetAvatar.dart';
import 'package:follow/wiget/widgetButton.dart';

class MemnerInfoPage extends StatefulWidget {
  const MemnerInfoPage({Key key, this.memberId}) : super(key: key);
  final String memberId;

  @override
  _MemnerInfoPageState createState() => _MemnerInfoPageState();
}

class _MemnerInfoPageState extends State<MemnerInfoPage> {
  EntityFriendSearch friendInfo;
  @override
  void initState() {
    super.initState();
    this.refreshData();
    SocketUtil.hubConnection.on("/common/message", (arguments) {
      EntityNoticeTemple temple = EntityNoticeTemple.fromJson(arguments[0]);
      if (temple.type == 3 && temple.senderId == this.widget.memberId) {
        this.refreshData();
      }
    });
    // _subscription = SocketUtil.mStream.listen((event) {
    //   EntityNoticeTemple temple = EntityNoticeTemple.fromJson(json.decode(event));
    //   if (temple.type == 3 && temple.senderId == this.widget.memberId) {
    //     this.refreshData();
    //   }
    // });
  }

  refreshData() {
    CommonUtil.whenRenderEnd((duration) {
      FriendApis().searchMemberInfo(this.widget.memberId ?? ReduxUtil.store.state.memberInfo.memberId).then((value) {
        if (value != null) {
          this.setState(() {
            this.friendInfo = value;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMe = this.friendInfo?.memberId == ReduxUtil.store.state.memberInfo.memberId;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  this.friendInfo?.coverUrl != null
                      ? Image.network(this.friendInfo?.coverUrl, fit: BoxFit.fill, height: 1.sWidth(), width: 1.sWidth())
                      : Container(
                          height: 1.sWidth(),
                          width: 1.sWidth(),
                          color: Theme.of(context).primaryColor,
                        ),
                  Container(
                    height: 1.sWidth(),
                    width: 1.sWidth(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WidgetAvatar(
                          url: this.friendInfo?.avatar,
                          size: 80,
                          padding: 3,
                        ).paddingExtension(EdgeInsets.only(bottom: 4.setHeight())).tapExtension(() {
                          if (isMe)
                            ImageUtil().uploadImg(context, clip: true).then((value) async {
                              if (value != null) {
                                await MemberApi().settingAvatar(value);
                                MemberHelper().updateMemberInfo();
                                this.refreshData();
                              }
                            });
                        }),
                        Text(this.friendInfo?.remark ?? this.friendInfo?.nickName ?? "", style: TextStyle(color: Colors.white, fontSize: 20.setSp()))
                            .paddingExtension(EdgeInsets.only(bottom: 8.setHeight())),
                        Text(this.friendInfo?.signature ?? "", style: TextStyle(color: Color(0XFFF7F7F7), fontSize: 14.setSp())).paddingExtension(EdgeInsets.only(bottom: 4.setHeight())),
                        isMe
                            ? Container(height: 60.setHeight())
                            : WidgetButton(
                                type: WidgetButtonType.primary,
                                filled: false,
                                child: (this.friendInfo?.isFriend ?? false)
                                    ? Text("发起聊天")
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add, color: Colors.white).paddingExtension(EdgeInsets.only(right: 4.setWidth())),
                                          Text('添加好友'),
                                        ],
                                      ),
                                onPressed: () {
                                  if (!(this.friendInfo?.isFriend ?? false)) {
                                    RouterUtil.push(
                                        context,
                                        AddFriendsPage(
                                          memberId: this.friendInfo.memberId,
                                          name: this.friendInfo.nickName,
                                        ));
                                  } else {
                                    ChatMessageUtil().startChat(this.widget.memberId);
                                    // MessageUtil().startSession(context, this.widget.memberId, false);
                                  }
                                },
                                width: 100.setWidth(),
                              ).paddingExtension(EdgeInsets.only(bottom: 40.setHeight()))
                        // (!isMe && !(this.friendInfo?.isFriend ?? false))
                        //     ? WidgetButton(
                        //         type: WidgetButtonType.primary,
                        //         filled: false,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Icon(Icons.add, color: Colors.white).paddingExtension(EdgeInsets.only(right: 4.setWidth())),
                        //             Text('添加好友'),
                        //           ],
                        //         ),
                        //         onPressed: () {
                        //           RouterUtil.push(
                        //               context,
                        //               AddFriendsPage(
                        //                 memberId: this.friendInfo.memberId,
                        //                 name: this.friendInfo.nickName,
                        //               ));
                        //         },
                        //         width: 100.setWidth(),
                        //       )
                        //     : Container(
                        //         padding: EdgeInsets.only(bottom: 16.setHeight()),
                        //         alignment: Alignment.center,
                        //         child: WidgetButton(
                        //           width: 100.setWidth(),
                        //           filled: false,
                        //           onPressed: () {
                        //             MessageUtil().startSession(context, this.widget.memberId, false);
                        //           },
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [Text("发起聊天")],
                        //           ),
                        //         ),
                        //       ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: List<Widget>.generate(5, (index) {
                        //     return ((index + 1) % 2) == 0
                        //         ? Container(
                        //             height: 20,
                        //             child: Column(
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: List<Widget>.generate(5, (index) => Container(width: 2, height: 2, color: Colors.white)),
                        //             ),
                        //           )
                        //         : Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               Text(["366", "80", "3333"][(index / 2).floor()], style: TextStyle(color: Colors.white, fontSize: 18.setSp())),
                        //               Text(["朋友", "关注", "粉丝"][(index / 2).floor()], style: TextStyle(color: Colors.white, fontSize: 14.setSp())).paddingExtension(EdgeInsets.only(top: 4.setHeight()))
                        //             ],
                        //           ).paddingExtension(EdgeInsets.symmetric(horizontal: 24.setWidth()));
                        //   }),
                        // ).paddingExtension(EdgeInsets.symmetric(vertical: 24.setHeight())),
                        /// 暂时先不要
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       height: 30.setHeight(),
                        //       width: 123.setWidth(),
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0XFF22A7F0), Color(0XFF3A75C2)]), borderRadius: BorderRadius.circular(40)),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Icon(Icons.add, color: Colors.white).paddingExtension(EdgeInsets.only(right: 4.setWidth())),
                        //           Text("关注", style: TextStyle(color: Colors.white, fontSize: 15.setSp())),
                        //         ],
                        //       ),
                        //     ),
                        //     Container(width: 35.setWidth()),
                        //     Container(
                        //       height: 30.setHeight(),
                        //       width: 123.setWidth(),
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Icon(Icons.add, color: Theme.of(context).primaryColor).paddingExtension(EdgeInsets.only(right: 4.setWidth())),
                        //           Text("添加", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.setSp())),
                        //         ],
                        //       ),
                        //     ).tapExtension(() {
                        //       RouterUtil.push(context, AddFriendsPage());
                        //     })
                        //   ],
                        // ).paddingExtension(EdgeInsets.only(bottom: 30.setHeight()))
                      ],
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withAlpha(0), Colors.black.withAlpha(50), Colors.black.withAlpha(190)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: 1.sWidth(),
                height: 50.setHeight(),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(30, 0, 0, 0),
                      spreadRadius: 2.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 32.setWidth()),
                child: Text("最近动态", style: Theme.of(context).textTheme.bodyText1),
              ),
              Center(
                child: Text("暂无动态"),
              ).paddingExtension([16, 32].setPadding()),
              // Container(
              //   child: Column(
              //     children: [
              //       Row(
              //         children: [
              //           Icon(Icons.access_time),
              //           Text("2017-11-11 12:12:12", style: Theme.of(context).textTheme.bodyText1).paddingExtension(EdgeInsets.only(left: 4.setWidth())),
              //         ],
              //       ),
              //       Text(
              //         "Leading into Google I/O, one session caught everyone’s attention. Google ATAP — the company’s skunkworks…",
              //         style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12.setSp()),
              //       ).paddingExtension(EdgeInsets.only(top: 8.setHeight())),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Text("浏览了32次", style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontSize: 13.setSp()))).flexExtension(),
              //           Row(
              //             children: [
              //               Icon(Icons.message, size: 24.setSp(), color: Color(0XFF999999).withAlpha(100)),
              //               Text("123", style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontSize: 13.setSp()))).paddingExtension(EdgeInsets.only(left: 8.setWidth()))
              //             ],
              //           ).paddingExtension(16.setPaddingHorizontal()),
              //           Row(
              //             children: [
              //               Icon(Icons.thumb_up, size: 24.setSp(), color: Color(0XFF999999).withAlpha(100)),
              //               Text("123", style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontSize: 13.setSp()))).paddingExtension(EdgeInsets.only(left: 8.setWidth()))
              //             ],
              //           ),
              //         ],
              //       ).paddingExtension(EdgeInsets.only(top: 16.setHeight())),
              //     ],
              //   ),
              // ).paddingExtension([16, 32].setPadding()),
              // Divider()
            ],
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            // actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
          ).containerExtension(height: kToolbarHeight + MediaQuery.of(context).padding.top),
        ],
      ),
    );
  }
}
