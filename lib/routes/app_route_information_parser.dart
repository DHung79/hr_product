import 'package:flutter/material.dart';
import 'route_names.dart';
import 'route_path.dart';

class AppRouteInforParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    final name = uri.path;

    if (name == initialRoute) {
      return AppRoutePath.initial();
    }
    //authentication
    if (name == homeRoute) {
      return AppRoutePath.home();
    }
    if (name == authenticationRoute) {
      return AppRoutePath.authentication();
    }
    if (name == forgotPasswordRoute) {
      return AppRoutePath.forgotPassword();
    }
    if (name == otpRoute) {
      return AppRoutePath.otp();
    }
    if (name == resetPasswordRoute) {
      return AppRoutePath.resetPassword();
    }
    return AppRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: pageNotFoundRoute);
    }
    return RouteInformation(location: configuration.name);
  }
}
