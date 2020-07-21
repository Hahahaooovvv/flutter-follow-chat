class EntityMemberInfo {
  String memberId;
  String nickName;
  String followId;
  String token;
  String avatar;
  int gender;
  String signature;
  String cover;

  EntityMemberInfo({this.memberId, this.nickName, this.followId, this.token, this.avatar, this.gender, this.cover});

  EntityMemberInfo.fromJson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    nickName = json['nickName'];
    followId = json['followId'];
    token = json['token'];
    avatar = json['avatar'];
    gender = json['gender'];
    signature = json['signature'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberId'] = this.memberId;
    data['nickName'] = this.nickName;
    data['followId'] = this.followId;
    data['token'] = this.token;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['signature'] = this.signature;
    data["cover"] = this.cover;
    return data;
  }
}
