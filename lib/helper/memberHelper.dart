import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:follow/Entrance.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/bottomNavigationBar.dart';
import 'package:follow/entity/apis/entityMemberApi.dart';
import 'package:follow/entity/enum/sharedPreferences.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/commonUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/routerUtil.dart';
import 'package:follow/utils/socketUtil.dart';

class MemberHelper {
  /// 用户登录
  void login(BuildContext context, String account, String password) async {
    // String loginMemberId = await this.memberLoginId();
    if (account.length < 4) {
      ModalUtil.toastMessage("请输入正确的账号");
    } else if (password.length < 4) {
      ModalUtil.toastMessage("请输入正确的密码");
    } else {
      new MemberApi().userLogin(account, password).then((memberInfo) async {
        if (memberInfo != null) {
          await this.cacheUserLoginToLocal(memberInfo);
          this.cacheMemberInfoToRedux(memberInfo);
          RouterUtil.pushAndRemoveUntil(context, BottomNavigationBarPage());
        }
      });
    }
  }

  /// 持久化缓存用户信息
  /// 此处不止存储一个用户的信息
  Future<void> cacheUserLoginToLocal(EntityMemberInfo memberInfo, [bool isLogin = true]) async {
    await CommonUtil.getSharedPreferencesInstance().then((instance) async {
      List<String> userInfoList = instance.getStringList(SharePreferencesKeys.USERINFO.toString()) ?? [];
      int _index = userInfoList.indexWhere((element) => EntityMemberInfo.fromJson(json.decode(element)).memberId == memberInfo.memberId);
      if (_index > -1) {
        userInfoList[_index] = json.encode(memberInfo.toJson());
      } else {
        userInfoList.add(json.encode(memberInfo.toJson()));
      }
      await instance.setStringList(SharePreferencesKeys.USERINFO.toString(), userInfoList);
      await this.changeMemberLoginInstance(memberInfo);
    });
  }

  /// 切换当前登录的用户
  /// 用于多用户切换
  Future<void> changeMemberLoginInstance(EntityMemberInfo memberInfo) async {
    await CommonUtil.getSharedPreferencesInstance().then((instance) async {
      await instance.setString(SharePreferencesKeys.USERLOGINID.toString(), memberInfo.memberId);
    });
  }

  /// 获取当前处于登录中的用户ID
  Future<String> memberLoginId() async {
    return await CommonUtil.getSharedPreferencesInstance().then((instance) async {
      return instance.getString(SharePreferencesKeys.USERLOGINID.toString());
    });
  }

  Future<EntityMemberInfo> getMemberInfoFromLocal([String memberId]) async {
    memberId ??= await this.memberLoginId();
    if (memberId == null) {
      return Future.value(null);
    }
    return await CommonUtil.getSharedPreferencesInstance().then((instance) async {
      List<EntityMemberInfo> userInfoList = (instance.getStringList(SharePreferencesKeys.USERINFO.toString()) ?? []).map((element) {
        return EntityMemberInfo.fromJson(json.decode(element));
      }).toList();
      return userInfoList.firstWhere((element) => element.memberId == memberId, orElse: () => null);
    });
  }

  /// 存入用户信息到redux中去
  void cacheMemberInfoToRedux(EntityMemberInfo memberInfo) {
    ReduxUtil.dispatch(ReduxActions.MEMBER_INFO, memberInfo);
    // ReduxUtil.store.dispatch(reduxac(ReduxActions.MEMBER_CACHE_INFO, memberInfo));
  }

  /// 更新用户信息
  Future<void> updateMemberInfo() {
    return MemberApi().getMemberInfo().then((value) async {
      if (value != null) {
        this.cacheUserLoginToLocal(value);
        this.cacheMemberInfoToRedux(value);
      }
    });
  }

  /// 退出登录
  Future<void> signOut(BuildContext context) async {
    await CommonUtil.getSharedPreferencesInstance().then((instance) async {
      /// 清除登录记录
      await instance.remove(SharePreferencesKeys.USERLOGINID.toString());

      /// 清除redux数据
      new SocketUtil().close();

      /// 跳转到登录页面
      await RouterUtil.pushAndRemoveUntil(context, EntrancePage(isFirst: false));
      this.cacheMemberInfoToRedux(null);
    });
  }
}
