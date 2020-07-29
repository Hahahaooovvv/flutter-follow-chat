import 'package:follow/utils/reduxUtil.dart';
import 'package:sqflite/sqflite.dart';

class SqlTemple {
  String sqlStr;
  List<dynamic> dataList;
}

class SqlLiteHelper {
  Database database;

  Future<Database> openDataBase() async {
    if (this.database != null) {
      return this.database;
    }
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "/chat_${ReduxUtil.store.state.memberInfo.memberId}.db";
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // chat_type 0 好友单聊
        // msg_type 0 文本 1 图片 2 视屏  3 撤回消息
        // status 0未送达 1已送达
        // local_msg_id 消息送达后，后端会给前端回执是否发送成功
        await db.execute('''
          CREATE TABLE chat_message (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            sender_id TEXT, 
            session_id TEXT,
            chat_type INTEGER, 
            is_read INTEGER,
            sender_time TEXT,
            msg_type INTEGER,
            msg TEXT,
            at_members TEXT,
            status INTEGER,
            msgId TEXT,
            local_msg_id TEXT
            )
          ''');
      },
    );
    this.database = database;
    return database;
  }

  Future<void> closeDataBase() async {
    if (this.database.isOpen) {
      await this.database.close();
    }
  }

  /// 根据返回的数据获取map
  List<Map<String, dynamic>> getMapFromQueryData(List<Map<String, dynamic>> data) {
    return data.map((e) {
      Map<String, dynamic> map = {};
      e.forEach((key, value) {
        map[key] = value;
      });
      return map;
    }).toList();
  }
}
