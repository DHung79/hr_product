import 'package:hr_product/core/base/logger/logger.dart';

class JTValidator {
  static String? passwordValidator(
    String? value,
    Function(bool) isValidate,
    Function(String) errorMessage,
  ) {
    if (value!.trim().isEmpty) {
      isValidate(true);
      errorMessage('Mật khẩu không được để trống');
      return '';
    }
    if (value.length < 6) {
      isValidate(true);
      errorMessage('Mật khẩu có ít nhất 6 kí tự');
      return '';
    }
    if (value.length > 20) {
      isValidate(true);
      errorMessage('Mật khẩu có nhiều nhất 20 kí tự');
      return '';
    }
    String hasLetter = r'(?=.*?[A-z])';
    String hasNumber = r'^(?=.*?[0-9])';

    if (!RegExp(hasLetter).hasMatch(value) ||
        !RegExp(hasNumber).hasMatch(value)) {
      isValidate(true);
      errorMessage('Mật khẩu bao gồm ít nhất 1 chữ hoặc 1 số');
      return '';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      isValidate(true);
      errorMessage('Mật khẩu bao gồm ít nhất 1 chữ cái viết hoa');
      return '';
    } else {
      errorMessage('');
      isValidate(false);
      return null;
    }
  }
}
