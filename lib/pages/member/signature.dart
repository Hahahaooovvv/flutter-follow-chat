import 'package:flutter/material.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/helper/memberHelper.dart';
import 'package:follow/utils/extensionUtil.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/utils/reduxUtil.dart';

class SignaturePage extends StatefulWidget {
  SignaturePage({Key key}) : super(key: key);

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  submit() async {
    if (signature.isNotEmpty) {
      if (!await MemberApi().settingSignature(signature)) {
        return;
      }
      ModalUtil.toastMessage("修改成功");
      await MemberHelper().updateMemberInfo();
    }
    Navigator.pop(context);
  }

  String signature = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('修改签名'),
        actions: [
          FlatButton(
            onPressed: this.submit,
            textColor: Colors.white,
            child: Text("修改"),
          ),
        ],
      ),
      body: TextField(
        onChanged: (str) {
          this.signature = str;
        },
        decoration: InputDecoration(
          hintText: ReduxUtil.store.state.memberInfo.signature ?? "请输入签名",
          hintStyle: TextStyle(fontSize: 14.setSp()),
        ),
      ).paddingExtension(16.setPaddingAll()),
    );
  }
}
