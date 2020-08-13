import 'package:follow/utils/reduxUtil.dart';
import 'package:sqflite/sqflite.dart';

class SqlTemple {
  String sqlStr;
  List<dynamic> dataList;
}

class SqlLiteHelper {
  static Database dbInstance;

  Database database;

  /// 初始化sqllite
  initSqlLite() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "/chat_${ReduxUtil.store.state.memberInfo.memberId}.db";
    print(path);
    SqlLiteHelper.dbInstance = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
       CREATE TABLE chat_msg (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          "msgId" TEXT,
          "sessionId" TEXT NOT NULL,
          "chatType" INTEGER NOT NULL,
          "msg" TEXT NOT NULL,
          "status" INTEGER NOT NULL,
          "localStatus" INTEGER NOT NULL,
          "msgType" INTEGER NOT NULL,
          "localId" TEXT,
          "time" INTEGER NOT NULL,
          "atMembersId" TEXT,
          "isRead" INTEGER NOT NULL DEFAULT 0,
          "isWithdraw" INTEGER NOT NULL DEFAULT 0,
          "senderId" TEXT NOT NULL
      );
      ''');
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
  }

  Future<Database> openDataBase() async {
    this.database = SqlLiteHelper.dbInstance;
    return Future.value(SqlLiteHelper.dbInstance);
  }

// /Users/zhangdengchuan/Library/Developer/CoreSimulator/Devices/18D5028D-C919-4407-9D3F-5AEDFACE22BF/data/Containers/Data/Application/40F5ED99-9F76-4686-BB62-1ED1C96D9F69/Documents/chat3_7a3fe7aabce54c50a5ce40b1e095efe8.db
  Future<void> closeDataBase() async {
    // if (this.database.isOpen) {
    //   await this.database.close();
    // }
  }

  static Future<void> execute(String strSql, [List<dynamic> datas]) async {
    await SqlLiteHelper.dbInstance.execute(strSql, datas ?? []);
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

extension SqlUtilExtension on Future<List<Map<String, dynamic>>> {
  Future<List<Map<String, dynamic>>> toListMap() async {
    return new SqlLiteHelper().getMapFromQueryData(await this);
  }
}
