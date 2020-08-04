class EnityBriefMemberInfo {
  String sessionId;
  String name;
  String remark;
  String avatar;
  bool isGroup;
  String nameOrRemark;

  EnityBriefMemberInfo({this.sessionId, this.name, this.remark, this.avatar, this.isGroup});

  EnityBriefMemberInfo.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    name = json['name'];
    remark = json['remark'];
    avatar = json['avatar'];
    isGroup = json['isGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionId'] = this.sessionId;
    data['name'] = this.name;
    data['remark'] = this.remark;
    data['avatar'] = this.avatar;
    data['isGroup'] = this.isGroup;
    return data;
  }
}
