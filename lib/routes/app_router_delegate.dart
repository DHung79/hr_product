import 'package:flutter/material.dart';
import 'no_animation_transition_delegate.dart';
import 'route_path.dart';
import '../main.dart';
import '../screens/forgot_password/forgot_password_screen.dart';
import '../screens/onboarding/authentication_screen.dart';
import '../screens/register/register_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  String _routePath = '';

  @override
  AppRoutePath get currentConfiguration => AppRoutePath.routeFrom(_routePath);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: NoAnimationTransitionDelegate(),
      pages: [
        _pageFor(_routePath),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        notifyListeners();

        return true;
      },
    );
  }

  _pageFor(String route) {
    return MaterialPage(
      key: const ValueKey('HomeService'),
      child: _screenFor(route),
    );
  }

  _screenFor(String route) {
    if (route == initialRoute || route == authenticationRoute) {
      return const AuthenticationScreen();
    }
    if (route == forgotPasswordRoute) {
      return const ForgotPasswordScreen();
    }
    if (route == otpForgotPasswordRoute) {
      return const ForgotPasswordScreen(
        pageIndex: 2,
      );
    }
    if (route == resetPasswordRoute) {
      return const ForgotPasswordScreen(
        pageIndex: 3,
      );
    }
    if (route == registerRoute) {
      return const RegisterScreen();
    }
    if (route == otpRegisterRoute) {
      return const RegisterScreen(
        pageIndex: 2,
      );
    }
    if (route == enterUserInfoRoute) {
      return const RegisterScreen(
        pageIndex: 3,
      );
    }
    // if (route.startsWith(homeRoute)) {
    //   if (route.length > homeRoute.length) {
    //     final id = route.substring(homeRoute.length + 1, route.length);
    //     if (id.isNotEmpty) return SinglePostPage(postId: id);
    //   }
    //   return const ChopperScreen();
    // }
    return const SizedBox();
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _routePath = configuration.name!;
  }

  void navigateTo(String name) {
    preRoute = _routePath;
    _routePath = name;
    notifyListeners();
  }
}
