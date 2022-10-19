import 'route_names.dart';

class AppRoutePath {
  final String? name;
  final String routeId;
  final bool isUnknown;

  AppRoutePath.initial()
      : name = initialRoute,
        routeId = '',
        isUnknown = false;
  //authentication
  AppRoutePath.authentication()
      : name = authenticationRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.home()
      : name = homeRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.forgotPassword()
      : name = forgotPasswordRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.otpForgotPassword()
      : name = otpForgotPasswordRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.otpRegister()
      : name = otpRegisterRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.resetPassword()
      : name = resetPasswordRoute,
        routeId = '',
        isUnknown = false;

  AppRoutePath.unknown()
      : name = null,
        routeId = '',
        isUnknown = true;

  static AppRoutePath routeFrom(String? name) {
    if (name == initialRoute) {
      return AppRoutePath.initial();
    }
    //authentication
    if (name == authenticationRoute) {
      return AppRoutePath.authentication();
    }
    if (name == forgotPasswordRoute) {
      return AppRoutePath.forgotPassword();
    }
    if (name == otpForgotPasswordRoute) {
      return AppRoutePath.otpForgotPassword();
    }
    if (name == otpRegisterRoute) {
      return AppRoutePath.otpRegister();
    }
    if (name == resetPasswordRoute) {
      return AppRoutePath.resetPassword();
    }
    if (name == homeRoute) {
      return AppRoutePath.home();
    }

    return AppRoutePath.unknown();
  }
}
