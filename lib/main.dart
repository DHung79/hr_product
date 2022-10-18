import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../locator.dart';
import '../routes/app_route_information_parser.dart';
import '../routes/app_router_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scroll_behavior.dart';
import 'themes/jt_theme.dart';
import 'utils/app_state_notifier.dart';
export 'core/authentication/bloc/authentication_bloc_controller.dart';
export '/routes/route_names.dart';
export '/screens/layout_template/content_screen.dart';
export '/core/base/logger/logger.dart';

//page index
// int homePageIndex = 0;
// int selectIndexBooking = 0;
//get fcm
// String? currentFcmToken;
String preRoute = '';

Future<SharedPreferences> prefs = SharedPreferences.getInstance();
GlobalKey globalKey = GlobalKey();

navigateTo(String route) async {
  locator<AppRouterDelegate>().navigateTo(route);
}

String? getCurrentRoute() {
  return locator<AppRouterDelegate>().currentConfiguration.name;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  setupLocator();
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (_) => AppStateNotifier(),
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
  static State<App>? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  final AppRouteInforParser _routeInfoParser = AppRouteInforParser();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp.router(
          title: 'Home Service',
          debugShowCheckedModeBanner: false,
          theme: JTThemeConfig.lightTheme,
          darkTheme: JTThemeConfig.darkTheme,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routeInformationParser: _routeInfoParser,
          routerDelegate: locator<AppRouterDelegate>(),
          builder: (context, child) => child!,
          scrollBehavior: MyCustomScrollBehavior(),
        );
      },
    );
  }
}
