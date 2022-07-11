import 'package:flutter_online_shop/exceptions/auth/firebase_exception.dart';

///Kế thừa class abstract MessagedFirebaseAuthException

class FirebaseCredentialActionAuthException
    extends MessagedFirebaseAuthException {
  FirebaseCredentialActionAuthException(
      {String message = "Instance of FirebasePasswordActionAuthException"})
      : super(message);
}

//Bắt exception [Không tồn tại user]

class FirebaseCredentialActionAuthUserNotFoundException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthUserNotFoundException(
      {String message = "No such user exist"})
      : super(message: message);
}

//Bắt exception [Mật khẩu yếu]

class FirebaseCredentialActionAuthWeakPasswordException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthWeakPasswordException(
      {String message = "Password is weak, try something better"})
      : super(message: message);
}

//Bắt exception [Yêu cầu đăng nhập lại]

class FirebaseCredentialActionAuthRequiresRecentLoginException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthRequiresRecentLoginException(
      {String message = "This action requires re-Login"})
      : super(message: message);
}

//Bắt exception [Đăng nhập thất bại bởi lỗi không xác định]

class FirebaseCredentialActionAuthUnknownReasonFailureException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthUnknownReasonFailureException(
      {String message = "The action can't be performed due to unknown reason"})
      : super(message: message);
}
