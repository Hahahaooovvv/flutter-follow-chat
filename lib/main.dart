import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:follow/Entrance.dart';
import 'package:follow/config.dart';
import 'package:follow/redux.dart';
import 'package:follow/utils/chineseLocalLizations.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/reduxUtil.dart';
import 'package:follow/utils/requestUtils.dart';
import 'package:one_context/one_context.dart';
import 'package:redux/redux.dart';

void main() {
  // ScreenUtil.init(width: 750, height: 1334, allowFontScaling: false);
  setDesignWHD(360.0, 640.0, density: 3);
  RequestHelper.initInstance();
  final store = new Store<ReduxStore>(iniReducer, initialState: ReduxStore());
  // 初始化config
  Config.instance;
  runApp(MyApp(store: store));
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark);
  // if (Platform.isAndroid) {
  // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // }
}

class MyApp extends StatefulWidget {
  final Store<ReduxStore> store;

  const MyApp({Key key, this.store}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ReduxUtil.store = this.widget.store;
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<ReduxStore>(
        store: widget.store,
        child: MaterialApp(
          localizationsDelegates: [
            ChineseCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: Locale('zh', 'CH'),
          supportedLocales: [
            const Locale('zh', 'CN'),
            const Locale('en', 'US'),
          ],
          builder: OneContext().builder,
          title: 'Floow Chat',
          theme: ThemeData(
            textTheme: TextTheme(
              bodyText1: TextStyle(color: Color(0XFF999999), fontSize: 15.setSp(), fontWeight: FontWeight.normal),
              bodyText2: TextStyle(color: Color(0XFF666666), fontSize: 15.setSp()),
            ),
            iconTheme: IconThemeData(color: Color(0XFF999999)),
            dividerTheme: DividerThemeData(space: 0, thickness: 0),
            scaffoldBackgroundColor: Color(0XFFFAFAFA),
            appBarTheme: AppBarTheme(
              centerTitle: false,
              actionsIconTheme: IconThemeData(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            primarySwatch: Colors.blue,
            primaryColor: Color.fromARGB(255, 100, 142, 247),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: EntrancePage(),
        )
        // FlutterEasyLoading(
        //     child:)

        );
  }
}
