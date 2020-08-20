class EnityBriefMemberInfo {
  /// 用户ID
  String sessionId;

  /// 昵称
  String name;

  /// 备注
  String remark;

  /// 头像
  String avatar;

  /// 是否群组
  bool isGroup;

  /// 昵称或者备注
  /// 优先备注
  String nameOrRemark;

  EnityBriefMemberInfo({this.sessionId, this.name, this.remark, this.avatar, this.isGroup, this.nameOrRemark});

  EnityBriefMemberInfo.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    name = json['name'];
    remark = json['remark'];
    avatar = json['avatar'];
    isGroup = (json['isGroup'] is int) ? (json['isGroup'] == 1 ? true : false) : json['isGroup'];
    nameOrRemark = json['remark'] ?? json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionId'] = this.sessionId;
    data['name'] = this.name;
    data['remark'] = this.remark;
    data['avatar'] = this.avatar;
    data['isGroup'] = this.isGroup == true ? 1 : 0;
    return data;
  }

  /// 存入数据库
  void toDB() {}
}

// extension EntityChatMessageExtension on List<EnityBriefMemberInfo> {
//   Map<String, dynamic> toSql() {
//     String strSql = "";
//     List<dynamic> data = [];
//     this.forEach((element) {
//       String keys = "";
//       String values = "";
//       var _json = element.toJson();
//       _json.keys.toList().forEach((e) {
//         if (_json[e] != null) {
//           keys += keys.isNotEmpty ? "," + e : e;
//           values += values.isNotEmpty ? ",?" : "?";
//           data.add(_json[e]);
//         }
//       });
//       strSql += "INSERT INTO CHAT_MSG($keys) VALUES($values);";
//     });
//     return {"sql": strSql, "data": data};
//   }
// }
