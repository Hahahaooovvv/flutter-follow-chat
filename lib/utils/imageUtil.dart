import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:follow/apis/memberApi.dart';
import 'package:follow/utils/modalUtils.dart';
import 'package:follow/wiget/widgetPopSelectModal.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtil {
  /// 选择照片
  Future<File> selectImagePopSelect(BuildContext context, {ImageSource source}) async {
    Completer<File> completer = Completer();
    if (source != null) {
      completer.complete(await ImagePicker.pickImage(source: source));
    } else {
      ModalUtil.showPopSelect<String>(context, children: [
        WidgetPopSelectModalItem(childStr: "拍照", value: "0"),
        WidgetPopSelectModalItem(childStr: "从相册中选择", value: "1"),
      ], onSelect: (value) async {
        File image;
        if (value == "0") {
          image = await ImagePicker.pickImage(source: ImageSource.camera);
        } else {
          image = await ImagePicker.pickImage(source: ImageSource.gallery);
        }
        completer.complete(image);
      });
    }
    return completer.future;
  }

  /// 获取图片大小
  Future<Size> getImageSize(File file) {
    Completer<Size> completer = Completer();
    Image image = Image.file(file);
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((_image, bo) {
      completer.complete(Size(_image.image.width.toDouble(), _image.image.height.toDouble()));
    }));
    return completer.future;
  }

  /// 文件转base64
  Future<String> fileToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  /// 上传头像
  Future<String> upLoadAvatar(BuildContext context, {ImageSource source}) async {
    File _file = await this.selectImagePopSelect(context, source: source);
    if (_file?.path == null) {
      return null;
    } else if (!["png", "jpg"].contains(_file.path.split(".").reversed.toList()[0])) {
      ModalUtil.toastMessage("仅支持png、jpg格式图片");
      return null;
    }
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _file.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 10, ratioY: 10),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        maxWidth: 500,
        maxHeight: 500,
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioPickerButtonHidden: true,
          cancelButtonTitle: "取消",
          doneButtonTitle: "确定",
        ));
    return this.uploadImage(croppedFile);
  }

  /// 上传图片
  Future<String> uploadImage(File file) async {
    Size _size = await this.getImageSize(file);
    String base64 = await this.fileToBase64(file);
    return MemberApi().uploadImageByBase64(base64, _size.width, _size.height);
  }
}
