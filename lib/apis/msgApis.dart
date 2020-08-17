import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/entity/notice/EntityTimerChatMessage.dart';
import 'package:follow/utils/requestUtils.dart';
import 'package:follow/utils/sqlLiteUtil.dart';

class MsgApis {
  Future<EntityTimerChatMessage> getNewesMsgList() async {
    String time = await SqlLiteUtil().getSystemConfig(SqlUtilConfigKey.NEWES_LIST);
    return RequestHelper.request("/api/message/msg/newes", RequestMethod.GET, data: {"time": time}).then((value) {
      EntityTimerChatMessage timerChatMessage = EntityTimerChatMessage();
      List<EntityChatMessage> _list = [];
      if (value.data.success) {
        value.data.data["list"].forEach((p) {
          _list.add(EntityChatMessage.fromJson(p));
        });
      } else {
        return null;
      }

      return timerChatMessage
        ..time = value.data.data["lastTime"]
        ..list = _list;
    });
  }
}
