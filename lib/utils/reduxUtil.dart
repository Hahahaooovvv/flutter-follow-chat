import 'package:follow/redux.dart';
import 'package:redux/redux.dart';

class ReduxUtil {
  static Store<ReduxStore> store;

  /// 发起action
  static dispatch<T>(ReduxActions type, T data) {
    return ReduxUtil.store.dispatch(ReduxActionsEntity<T>(type, data));
  }
}
