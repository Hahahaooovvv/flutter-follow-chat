import 'package:follow/entity/member/ebriefMemberInfo.dart';
import 'package:follow/entity/notice/EntityChatMessage.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:sqflite/sqflite.dart';

class SqlUtilTemple {
  String sqlStr;
  List<dynamic> dataList;
  List<String> ids;
}

class SqlLiteUtil {
  static Database dbInstance;

  /// 初始化sqllite
  initSqlLite() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "/chat_${ReduxUtil.store.state.memberInfo.memberId}.db";
    print(path);
    SqlLiteUtil.dbInstance = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE "chat_msg" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          "msgId" TEXT,
          "sessionId" TEXT NOT NULL,
          "chatType" INTEGER NOT NULL,
          "msg" TEXT NOT NULL,
          "status" INTEGER NOT NULL,
          "localStatus" INTEGER NOT NULL,
          "msgType" INTEGER NOT NULL,
          "localId" TEXT,
          "time" TEXT NOT NULL,
          "atMembersId" TEXT,
          "isRead" INTEGER NOT NULL DEFAULT 0,
          "isWithdraw" INTEGER NOT NULL DEFAULT 0,
          "senderId" TEXT NOT NULL
          );
      ''');
        await db.execute('''
          CREATE TABLE "chat_message_timer" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          "sessionId" TEXT NOT NULL,
          "requestTime" TEXT NOT NULL
          );
      ''');
        await db.execute('''
          CREATE TABLE "ebrief_info" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          "sessionId" TEXT NOT NULL,
          "name" TEXT NOT NULL,
          "remark" TEXT,
          "avatar" TEXT NOT NULL,
          "isGroup" INTEGER NOT NULL
          );
      ''');
      },
    );
  }

  static String getKeys(int length) {
    return List<String>.generate(length, (index) => '?').join(",");
  }

  static Future<void> execute(String strSql, [List<dynamic> datas]) async {
    await SqlLiteUtil.dbInstance.execute(strSql, datas ?? []);
  }

  String getTableNameFromListType<T>(List<T> list) {
    String tableName = "";
    if (list is List<EntityChatMessage>) {
      tableName = "CHAT_MSG";
    } else if (list is List<EnityBriefMemberInfo>) {
      tableName = "EBRIEF_INFO";
    }
    return tableName;
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

  /// 获取插入语句
  SqlUtilTemple getInsertDbTStr<T>(List<T> list, {String tableName, String Function(T item) mapIds}) {
    tableName ??= getTableNameFromListType(list);
    String strSql = "";
    List<String> ids = mapIds == null ? null : [];
    List<dynamic> data = [];
    list.forEach((element) {
      String keys = "";
      String values = "";
      var _json = (element as dynamic).toJson();
      _json.keys.toList().forEach((e) {
        if (_json[e] != null) {
          keys += keys.isNotEmpty ? "," + e : e;
          values += values.isNotEmpty ? ",?" : "?";
          data.add(_json[e]);
        }
      });
      if (mapIds != null) {
        ids.add(mapIds(element));
      }
      strSql += "INSERT INTO $tableName($keys) VALUES($values);";
    });
    return SqlUtilTemple()
      ..ids = ids
      ..dataList = data
      ..sqlStr = strSql;
  }

  /// 获取List
  Future<List<T>> getListFromDB<T>(String strSql, {List<dynamic> data, T Function(Map<String, dynamic> item) mapToList}) async {
    List<Map<String, dynamic>> _query = SqlLiteUtil().getMapFromQueryData(await SqlLiteUtil.dbInstance.rawQuery(strSql, data));
    List<T> _list = <T>[];
    _query.forEach((element) {
      _list.add(mapToList(element));
    });
    return _list;
  }
}

extension SqlUtilExtension on Future<List<Map<String, dynamic>>> {
  Future<List<Map<String, dynamic>>> toListMap() async {
    return new SqlLiteUtil().getMapFromQueryData(await this);
  }
}
