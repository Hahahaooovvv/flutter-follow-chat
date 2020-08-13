import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WidgetImagePvreview extends StatefulWidget {
  WidgetImagePvreview({
    Key key,
    @required this.iniIndex,
    @required this.imageList,
  }) : super(key: key);
  final List<String> imageList;
  final int iniIndex;
  @override
  _WidgetImagePvreviewState createState() => _WidgetImagePvreviewState();
}

class _WidgetImagePvreviewState extends State<WidgetImagePvreview> {
  int index;
  @override
  void initState() {
    super.initState();
    this.index = widget.iniIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            color: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        child: Scaffold(
          body: Stack(
            children: [
              AppBar(brightness: Brightness.dark),
              Swiper(
                physics: ClampingScrollPhysics(),
                onTap: (int index) {
                  Navigator.pop(context);
                },
                loop: false,
                index: this.index,
                onIndexChanged: (index) {
                  setState(() {
                    this.index = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    widget.imageList[index],
                    width: MediaQuery.of(context).size.width,
                    // fit: BoxFit.fill,
                  );
                },
                itemCount: widget.imageList.length,
                pagination: new SwiperPagination(),
                // control: new SwiperControl(),
              )
            ],
          ),
        ));
  }
}
