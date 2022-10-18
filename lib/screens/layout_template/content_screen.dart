import 'package:flutter/material.dart';
import '../../main.dart';
import '../../themes/jt_theme.dart';

class PageTemplate extends StatefulWidget {
  final Widget child;
  const PageTemplate({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final listPageCanPop = [];
        final listTabCanPop = [];
        final currentRoute = getCurrentRoute();
        if (preRoute.isNotEmpty && !listPageCanPop.contains(currentRoute)) {
          if (listTabCanPop.contains(currentRoute)) {
            navigateTo(homeRoute);
          } else {
            navigateTo(preRoute);
          }
        }
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: JTColors.nWhite,
        body: widget.child,
      ),
    );
  }
}
