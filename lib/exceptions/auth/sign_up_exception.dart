import 'package:flutter_online_shop/exceptions/auth/firebase_exception.dart';

class FirebaseSignUpAuthException extends MessagedFirebaseAuthException {
  FirebaseSignUpAuthException(
      {String message: "Instance of FirebaseSignUpAuthException"})
      : super(message);
}

//Bắt exception [Xác nhận người dùng thất bại]

class FirebaseSignUpAuthEmailAlreadyInUseException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthEmailAlreadyInUseException(
      {String message = "Email đã tồn tại"})
      : super(message: message);
}

//Bắt exception [Email không hợp lệ]

class FirebaseSignUpAuthInvalidEmailException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthInvalidEmailException(
      {String message = "Email không hợp lệ"})
      : super(message: message);
}

//Bắt exception [Đăng kí bị hạn chế]

class FirebaseSignUpAuthOperationNotAllowedException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthOperationNotAllowedException(
      {String message = "Đăng ký bị hạn chế đối với người dùng này"})
      : super(message: message);
}

//Bắt exception [Mật khẩu yếu]

class FirebaseSignUpAuthWeakPasswordException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthWeakPasswordException(
      {String message = "Mật khẩu yếu, hãy thử mật khẩu tốt hơn"})
      : super(message: message);
}

//Bắt exception [Đăng kí tài khoản thất bại]

class FirebaseSignUpAuthUnknownReasonFailureException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthUnknownReasonFailureException(
      {String message = "Đăng kí tài khoản thất bại"})
      : super(message: message);
}
