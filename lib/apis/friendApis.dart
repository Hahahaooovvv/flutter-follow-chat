import 'package:follow/entity/apis/entityFriendApi.dart';
import 'package:follow/utils/requestUtils.dart';

class FriendApis {
  /// 搜索好友
  Future<EntityFriendSearch> searchMemberInfo(String searchStr) {
    return RequestHelper.request("/api/Friend/search", RequestMethod.GET, data: {"searchStr": searchStr}, errorTips: true, showLoading: true).then((value) {
      if (value.data.success) {
        return EntityFriendSearch.fromJson(value.data.data);
      } else {
        return null;
      }
    });
  }

  /// 修改备注名
  Future<bool> editRemark(String memberId, String remark) {
    return RequestHelper.request("/api/Friend/remark", RequestMethod.PUT, data: {"memberId": memberId, "remark": remark}, showLoading: true, errorTips: true).then((value) {
      return value.data.success;
    });
  }

  /// 申请添加好友
  Future<bool> apply(String memberId, String message, String remark, int channel) {
    return RequestHelper.request("/api/Friend/apply", RequestMethod.POST,
            data: {
              "memberId": memberId,
              "message": message,
              "channel": channel,
              "remark": remark,
            },
            showLoading: true,
            tips: true)
        .then((value) {
      return value.data.success;
    });
  }

  /// 添加好友回执
  Future<bool> ack(String recId, String remark, bool pass) {
    return RequestHelper.request("/api/Friend/add/ack", RequestMethod.POST,
            data: {
              "recId": recId,
              "remark": remark,
              "pass": pass,
            },
            showLoading: true,
            errorTips: true)
        .then((value) {
      return value.data.success;
    });
  }

  /// 消息回复
  Future<bool> returnMessage(String recId, String message) {
    return RequestHelper.request("/api/Friend/message/add", RequestMethod.POST,
            data: {
              "recId": recId,
              "message": message,
            },
            showLoading: true,
            errorTips: true)
        .then((value) {
      return value.data.success;
    });
  }

  /// 消息回复
  Future<List<EntityFriendAddRec>> addFriendRecList(String time) {
    return RequestHelper.request("/api/Friend/add/rec", RequestMethod.GET, data: {"time": time}).then((value) {
      List<EntityFriendAddRec> _list = [];
      if (value.data.success) {
        value.data.data.forEach((p) {
          _list.add(EntityFriendAddRec.fromJson(p));
        });
      }
      return _list;
    });
  }

  /// 获取好友列表
  Future<List<EntityFriendListInfo>> getFriendList() {
    return RequestHelper.request("/api/friend/list", RequestMethod.GET).then((value) {
      // print('object');
      List<EntityFriendListInfo> _list = [];
      if (value.data.success) {
        value.data.data.forEach((p) {
          _list.add(EntityFriendListInfo.fromJson(p));
        });
      } else {
        return null;
      }

      return _list;
    });
  }
}
