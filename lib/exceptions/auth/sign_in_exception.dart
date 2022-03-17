import 'package:flutter_online_shop/exceptions/auth/firebase_exception.dart';

class FirebaseSignInAuthException extends MessagedFirebaseAuthException {
  FirebaseSignInAuthException(
      {String message: "Instance of FirebaseSignInAuthException"})
      : super(message);
}

//Bắt exception [Người dùng vô hiệu hoá]

class FirebaseSignInAuthUserDisabledException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserDisabledException(
      {String message = "Người dùng này đã bị vô hiệu hóa"})
      : super(message: message);
}

//Bắt exception [Không tồn tại người dùng]

class FirebaseSignInAuthUserNotFoundException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotFoundException(
      {String message = "Không tìm thấy người dùng này"})
      : super(message: message);
}

//Bắt exception [Email không hợp lệ]

class FirebaseSignInAuthInvalidEmailException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthInvalidEmailException(
      {String message = "Email không hợp lệ"})
      : super(message: message);
}

//Bắt exception [Sai mật khẩu]

class FirebaseSignInAuthWrongPasswordException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthWrongPasswordException({String message = "Sai mật khẩu"})
      : super(message: message);
}
//Bắt exception [Người dùng chưa được xác thực]

class FirebaseSignInAuthUserNotVerifiedException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotVerifiedException(
      {String message = "Người dùng này chưa được xác minh"})
      : super(message: message);
}

//Bắt exception [Đăng nhập thất bại]

class FirebaseSignInAuthUnknownReasonFailure
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUnknownReasonFailure(
      {String message = "Đăng nhập thất bại"})
      : super(message: message);
}
