import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
// import 'package:silktrader/widget/widgetRefresh.dart';

class WidgetPageRefreshData<T> {
  final List<T> dataList;
  final int totalCount;

  WidgetPageRefreshData({@required this.dataList, @required this.totalCount});
}

class WidgetPageRefreshController<T> {
  void Function() refresh;
  WidgetPageRefreshData<T> Function() getData;
  void Function(WidgetPageRefreshData<T> data) setData;
}

typedef ViewModelBuilder<ViewModel> = Widget Function(
  BuildContext context,
  ViewModel vm,
);

typedef WidgetPageRefreshMethod<T> = Future<WidgetPageRefreshData<T>> Function(int pageNo, int pageSize);

class WidgetPageRefresh<T> extends StatefulWidget {
  WidgetPageRefresh(
      {Key key,
      this.pageSize: 20,
      this.defaultPageNo: 1,
      this.keepKey,
      this.physics,
      this.shrinkWrap: false,
      @required this.itemBuilder,
      @required this.method,
      this.controller,
      this.separatorBuilder,
      this.headerWidget,
      this.empty,
      this.firstRefreshWidget,
      this.contentPadding})
      : super(key: key);

  final Widget headerWidget;
  final WidgetPageRefreshController<T> controller;
  final int pageSize;
  final int defaultPageNo;
  final String keepKey;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final WidgetPageRefreshMethod<T> method;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget Function(BuildContext context, int index) separatorBuilder;
  final Widget firstRefreshWidget;
  final bool empty;
  final EdgeInsetsGeometry contentPadding;
  @override
  _WidgetPageRefreshState<T> createState() => _WidgetPageRefreshState<T>();
}

class _WidgetPageRefreshState<ST> extends State<WidgetPageRefresh<ST>> with AutomaticKeepAliveClientMixin {
  List<ST> dataList = [];
  int pageNo;
  int totalCount = 0;
  @override
  void initState() {
    super.initState();
    this.pageNo = widget.defaultPageNo;
    if (widget.controller != null) {
      widget.controller.refresh = () {
        this.onRefresh();
      };
      widget.controller.getData = () {
        return WidgetPageRefreshData<ST>(dataList: this.dataList, totalCount: this.totalCount);
      };
      widget.controller.setData = (data) {
        setState(() {
          this.dataList = data.dataList;
          this.totalCount = data.totalCount;
        });
      };
    }
  }

  /// 开始刷新
  onRefresh() async {
    /// 翻到第一页
    setState(() {
      pageNo = 1;
    });
    WidgetPageRefreshData<ST> result = await widget.method(this.pageNo, widget.pageSize);
    setState(() {
      totalCount = result.totalCount;
      dataList = result.dataList;
    });
  }

  /// 开始加载
  Future<void> onLoadingMore() async {
    setState(() {
      pageNo = pageNo + 1;
    });
    try {
      WidgetPageRefreshData<ST> result = await widget.method(this.pageNo, widget.pageSize);
      setState(() {
        totalCount = result.totalCount;
        dataList.addAll(result.dataList);
        dataList = dataList;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      // emptyWidget: (((widget.empty ?? true) && dataList.length == 0) ? WidgetEmptyComponent() : null),
      onRefresh: () async {
        await this.onRefresh();
      },
      firstRefresh: true,
      firstRefreshWidget: widget.firstRefreshWidget ??
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
            color: Colors.white,
          ),
      onLoad: (this.totalCount > this.pageNo * widget.pageSize) ? this.onLoadingMore : null,
      child: ListView(
        children: <Widget>[
          widget.headerWidget ?? Container(),
          ListView.separated(
            padding: this.widget.contentPadding ?? EdgeInsets.all(0),
            separatorBuilder: widget.separatorBuilder ??
                (context, index) {
                  return Divider();
                },
            key: PageStorageKey(widget.keepKey),
            physics: NeverScrollableScrollPhysics(), // widget.physics,
            shrinkWrap: true, // widget.shrinkWrap,
            itemCount: this.dataList.length,
            itemBuilder: (context, index) {
              return widget.itemBuilder(context, this.dataList[index]);
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
