import 'package:flutter/material.dart';
  
class GetPasswordPage extends StatefulWidget {
  GetPasswordPage({Key key}) : super(key: key);
  
  @override
  _GetPasswordPageState createState() => _GetPasswordPageState();
}
  
class _GetPasswordPageState extends State<GetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('找回密码'),
      ),
      body: Center(child: Text('data')),
    );
  }
}