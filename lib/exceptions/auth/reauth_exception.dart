import 'package:flutter_online_shop/exceptions/auth/firebase_exception.dart';

///Kế thừa class abstract [MessagedFirebaseAuthException]

class FirebaseReauthException extends MessagedFirebaseAuthException {
  FirebaseReauthException(
      {String message: "Instance of FirebaseReauthException"})
      : super(message);
}

///Kế thừa class [FirebaseReauthException]

//Bắt exception [Không trùng khớp user hiện tại]

class FirebaseReauthUserMismatchException extends FirebaseReauthException {
  FirebaseReauthUserMismatchException(
      {String message: "User not matching with current user"})
      : super(message: message);
}

//Bắt exception [Không tồn tại user]

class FirebaseReauthUserNotFoundException extends FirebaseReauthException {
  FirebaseReauthUserNotFoundException({String message = "No such user exists"})
      : super(message: message);
}

//Bắt exception [Thông tin không hợp lệ]

class FirebaseReauthInvalidCredentialException extends FirebaseReauthException {
  FirebaseReauthInvalidCredentialException(
      {String message = "Invalid Credentials"})
      : super(message: message);
}

//Bắt exception [Email không hợp lệ]

class FirebaseReauthInvalidEmailException extends FirebaseReauthException {
  FirebaseReauthInvalidEmailException({String message = "Invalid Email"})
      : super(message: message);
}

//Bắt exception [Sai password]

class FirebaseReauthWrongPasswordException extends FirebaseReauthException {
  FirebaseReauthWrongPasswordException({String message = "Wrong password"})
      : super(message: message);
}

//Bắt exception [Mã xác nhận không hợp lệ]

class FirebaseReauthInvalidVerificationCodeException
    extends FirebaseReauthException {
  FirebaseReauthInvalidVerificationCodeException(
      {String message = "Invalid Verification Code"})
      : super(message: message);
}

//Bắt exception [ID xác nhận không hợp lệ]

class FirebaseReauthInvalidVerificationIdException
    extends FirebaseReauthException {
  FirebaseReauthInvalidVerificationIdException(
      {String message = "Invalid Verification ID"})
      : super(message: message);
}

//Bắt exception [Xác nhận người dùng thất bại]

class FirebaseReauthUnknownReasonFailureException
    extends FirebaseReauthException {
  FirebaseReauthUnknownReasonFailureException(
      {String message = "Reauthentification Failed due to unknown reason"})
      : super(message: message);
}
