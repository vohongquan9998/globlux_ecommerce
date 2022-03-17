import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_online_shop/exceptions/local_file/image_picking_exceptions.dart';
import 'package:flutter_online_shop/exceptions/local_file/local_files_exceptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> choseImageFromLocalFiles(
  BuildContext context, {
  int maxSizeInKB = 1024,
  int minSizeInKB = 5,
}) async {
  final PermissionStatus photoPermissionStatus =
      await Permission.photos.request();
  if (!photoPermissionStatus.isGranted) {
    throw LocalFileHandlingStorageReadPermissionDeniedException(
        message: "Bạn cần cho phép sử dụng quyền truy cập bộ nhớ");
  }

  final imgPicker = ImagePicker();
  final imgSource = await showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text("Chọn hình ảnh"),
        actions: [
          FlatButton(
            child: Text("Camera"),
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          FlatButton(
            child: Text("Bộ sưu tập"),
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      );
    },
    context: context,
  );
  if (imgSource == null)
    throw LocalImagePickingInvalidImageException(message: "Chưa chọn hình ảnh");
  final PickedFile imagePicked = await imgPicker.getImage(source: imgSource);
  if (imagePicked == null) {
    throw LocalImagePickingInvalidImageException();
  } else {
    final fileLength = await File(imagePicked.path).length();
    if (fileLength > (maxSizeInKB * 1024) ||
        fileLength < (minSizeInKB * 1024)) {
      throw LocalImagePickingFileSizeOutOfBoundsException(
          message: "Kích thước ảnh không được vượt quá 1MB");
    } else {
      return imagePicked.path;
    }
  }
}
