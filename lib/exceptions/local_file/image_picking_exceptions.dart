import 'package:flutter_online_shop/exceptions/local_file/local_files_exceptions.dart';

///Các exception về hình ảnh

class LocalImagePickingException extends LocalFileHandlingException {
  LocalImagePickingException(
      {String message = "Instance of ImagePickingException"})
      : super(message);
}

//Bắt exception [Hình ảnh không hợp lệ]

class LocalImagePickingInvalidImageException
    extends LocalImagePickingException {
  LocalImagePickingInvalidImageException(
      {String message = "Image chosen is invalid"})
      : super(message: message);
}

//Bắt exception [Kích thước hình ảnh vượt quá giới hạn cho phép]

class LocalImagePickingFileSizeOutOfBoundsException
    extends LocalImagePickingException {
  LocalImagePickingFileSizeOutOfBoundsException(
      {String message = "Image size not in given range"})
      : super(message: message);
}

//Bắt exception [Nguồn ảnh không hợp lệ]

class LocalImagePickingInvalidImageSourceException
    extends LocalImagePickingException {
  LocalImagePickingInvalidImageSourceException(
      {String message = "Image source is invalid"})
      : super(message: message);
}

//Bắt exception [Thật bại]

class LocalImagePickingUnknownReasonFailureException
    extends LocalImagePickingException {
  LocalImagePickingUnknownReasonFailureException(
      {String message = "Failed due to unknown reason"})
      : super(message: message);
}
