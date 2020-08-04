class EntityFriendSearch {
  String memberId;
  String followId;
  String avatar;
  String nickName;
  String remark;
  bool isFriend;
  int channel;
  String createTime;
  String makeFriendTime;
  List<EntityFriendSearchMessage> message;
  String signature;
  int gender;
  int addMessageStatus;
  String addFriendRecId;
  bool lunchApply;
  String coverUrl;

  EntityFriendSearch(
      {this.memberId,
      this.followId,
      this.avatar,
      this.nickName,
      this.remark,
      this.isFriend,
      this.channel,
      this.createTime,
      this.makeFriendTime,
      this.message,
      this.signature,
      this.gender,
      this.coverUrl,
      this.addMessageStatus,
      this.addFriendRecId,
      this.lunchApply});

  EntityFriendSearch.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    followId = json['followId'];
    avatar = json['avatar'];
    nickName = json['nickName'];
    remark = json['remark'];
    isFriend = json['isFriend'];
    coverUrl = json["coverUrl"];
    channel = json['channel'];
    createTime = json['createTime'];
    makeFriendTime = json['makeFriendTime'];
    lunchApply = json["lunchApply"];
    if (json['message'] != null) {
      message = new List<EntityFriendSearchMessage>();
      json['message'].forEach((v) {
        message.add(new EntityFriendSearchMessage.fromJson(v));
      });
    }
    signature = json['signature'];
    gender = json['gender'];
    addMessageStatus = json['addMessageStatus'];
    addFriendRecId = json['addFriendRecId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['coverUrl'] = this.coverUrl;
    data['followId'] = this.followId;
    data['avatar'] = this.avatar;
    data['nickName'] = this.nickName;
    data['remark'] = this.remark;
    data['isFriend'] = this.isFriend;
    data['channel'] = this.channel;
    data['createTime'] = this.createTime;
    data['makeFriendTime'] = this.makeFriendTime;
    if (this.message != null) {
      data['message'] = this.message.map((v) => v.toJson()).toList();
    }
    data['signature'] = this.signature;
    data['gender'] = this.gender;
    data['addMessageStatus'] = this.addMessageStatus;
    data['addFriendRecId'] = this.addFriendRecId;
    data['lunchApply'] = this.lunchApply;
    return data;
  }
}

class EntityFriendSearchMessage {
  int id;
  String recId;
  String friendAddRecId;
  String createTime;
  String content;
  String senderMemberId;
  String receiveMemberId;

  EntityFriendSearchMessage({this.id, this.recId, this.friendAddRecId, this.createTime, this.content, this.receiveMemberId, this.senderMemberId});

  EntityFriendSearchMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recId = json['recId'];
    friendAddRecId = json['friendAddRecId'];
    createTime = json['createTime'];
    content = json['content'];
    receiveMemberId = json['receiveMemberId'];
    senderMemberId = json['senderMemberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recId'] = this.recId;
    data['friendAddRecId'] = this.friendAddRecId;
    data['createTime'] = this.createTime;
    data['content'] = this.content;
    data['receiveMemberId'] = this.receiveMemberId;
    data['senderMemberId'] = this.senderMemberId;
    return data;
  }
}

class EntityFriendAddRec {
  String senderMemberId;
  String avatar;
  String receiveMemberId;
  bool lunchApply;
  String message;
  int status;
  String createTime;
  String recId;
  String remark;
  String nickName;
  int isRead;

  EntityFriendAddRec({this.senderMemberId, this.isRead, this.avatar, this.receiveMemberId, this.lunchApply, this.message, this.status, this.createTime, this.recId, this.remark, this.nickName});

  EntityFriendAddRec.fromJson(Map<String, dynamic> json) {
    senderMemberId = json['senderMemberId'];
    avatar = json['avatar'];
    receiveMemberId = json['receiveMemberId'];
    lunchApply = json['lunchApply'];
    message = json['message'];
    status = json['status'];
    createTime = json['createTime'];
    recId = json['recId'];
    remark = json['remark'];
    nickName = json['nickName'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderMemberId'] = this.senderMemberId;
    data['avatar'] = this.avatar;
    data['receiveMemberId'] = this.receiveMemberId;
    data['lunchApply'] = this.lunchApply;
    data['message'] = this.message;
    data['status'] = this.status;
    data['createTime'] = this.createTime;
    data['recId'] = this.recId;
    data['remark'] = this.remark;
    data['nickName'] = this.nickName;
    data['isRead'] = this.isRead;
    return data;
  }
}

class EntityFriendListInfo {
  int id;
  String recId;
  String nickName;
  String remark;
  String createTime;
  String memberId;
  String avatar;
  String localMemberId;
  String subTitle;

  EntityFriendListInfo({this.localMemberId, this.id, this.recId, this.nickName, this.remark, this.createTime, this.memberId, this.avatar});

  EntityFriendListInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recId = json['recId'];
    nickName = json['nickName'];
    remark = json['remark'];
    createTime = json['createTime'];
    memberId = json['memberId'];
    avatar = json['avatar'];
    localMemberId = json["localMemberId"];
    subTitle = json['subTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recId'] = this.recId;
    data['nickName'] = this.nickName;
    data['remark'] = this.remark;
    data['createTime'] = this.createTime;
    data['memberId'] = this.memberId;
    data['avatar'] = this.avatar;
    data['localMemberId'] = this.localMemberId;
    data['subTitle'] = this.subTitle;
    return data;
  }
}

class EntityFriendSplitChar<T> {
  final String char;
  final List<T> list;

  EntityFriendSplitChar(this.char, this.list);
}

class EntityNoticeTemple {
  String senderId;
  int type;
  String receiveId;
  String groupId;
  dynamic content;
  String createTime;
  int isRead;

  EntityNoticeTemple({this.senderId, this.type, this.receiveId, this.groupId, this.content, this.createTime, this.isRead});

  EntityNoticeTemple.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    type = json['type'];
    receiveId = json['receiveId'];
    groupId = json['groupId'];
    content = json['content'];
    createTime = json['createTime'];
    isRead = json["isRead"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['type'] = this.type;
    data['receiveId'] = this.receiveId;
    data['groupId'] = this.groupId;
    data['content'] = this.content;
    data["createTime"] = this.createTime;
    data["isRead"] = this.isRead;
    return data;
  }
}
