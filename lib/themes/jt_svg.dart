import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconData {
  String path;
  SvgIconData({required this.path});
}

class SvgIcons {
  static SvgIconData add = SvgIconData(
    path: 'assets/svg/add.svg',
  );
  static SvgIconData appointment = SvgIconData(
    path: 'assets/svg/appointment.svg',
  );
  static SvgIconData arrowBackward = SvgIconData(
    path: 'assets/svg/arrow_backward.svg',
  );
  static SvgIconData arrowForward = SvgIconData(
    path: 'assets/svg/arrow_forward.svg',
  );
  static SvgIconData arrowIosDownward = SvgIconData(
    path: 'assets/svg/arrow_ios_downward.svg',
  );
  static SvgIconData arrowIosForward = SvgIconData(
    path: 'assets/svg/arrow_ios_forward.svg',
  );
  static SvgIconData arrowIosUpward = SvgIconData(
    path: 'assets/svg/arrow_ios_upward.svg',
  );
  static SvgIconData arrowUpLeft = SvgIconData(
    path: 'assets/svg/arrow_up_left.svg',
  );
  static SvgIconData checkCircle = SvgIconData(
    path: 'assets/svg/check_circle.svg',
  );
  static SvgIconData check = SvgIconData(
    path: 'assets/svg/check.svg',
  );
  static SvgIconData checkBox = SvgIconData(
    path: 'assets/svg/checkbox.svg',
  );
  static SvgIconData checkMark = SvgIconData(
    path: 'assets/svg/checkmark.svg',
  );
  static SvgIconData circle = SvgIconData(
    path: 'assets/svg/circle.svg',
  );
  static SvgIconData closeCircle = SvgIconData(
    path: 'assets/svg/close_circle.svg',
  );
  static SvgIconData close = SvgIconData(
    path: 'assets/svg/close.svg',
  );
  static SvgIconData collection = SvgIconData(
    path: 'assets/svg/collection.svg',
  );
  static SvgIconData date = SvgIconData(
    path: 'assets/svg/date.svg',
  );
  static SvgIconData edit = SvgIconData(
    path: 'assets/svg/edit.svg',
  );
  static SvgIconData eyeOff = SvgIconData(
    path: 'assets/svg/eye_off.svg',
  );
  static SvgIconData eye = SvgIconData(
    path: 'assets/svg/eye.svg',
  );
  static SvgIconData filter = SvgIconData(
    path: 'assets/svg/filter.svg',
  );
  static SvgIconData google = SvgIconData(
    path: 'assets/svg/google.svg',
  );
  static SvgIconData home = SvgIconData(
    path: 'assets/svg/home.svg',
  );
  static SvgIconData info = SvgIconData(
    path: 'assets/svg/info.svg',
  );
  static SvgIconData key = SvgIconData(
    path: 'assets/svg/key.svg',
  );
  static SvgIconData lock = SvgIconData(
    path: 'assets/svg/lock.svg',
  );
  static SvgIconData mobilePhone = SvgIconData(
    path: 'assets/svg/mobile_phone.svg',
  );
  static SvgIconData play = SvgIconData(
    path: 'assets/svg/play.svg',
  );
  static SvgIconData questionCircle = SvgIconData(
    path: 'assets/svg/question_circle.svg',
  );
  static SvgIconData reload = SvgIconData(
    path: 'assets/svg/reload.svg',
  );
  static SvgIconData search = SvgIconData(
    path: 'assets/svg/search.svg',
  );
  static SvgIconData send = SvgIconData(
    path: 'assets/svg/send.svg',
  );
  static SvgIconData star = SvgIconData(
    path: 'assets/svg/star.svg',
  );
  static SvgIconData user = SvgIconData(
    path: 'assets/svg/user.svg',
  );
  static SvgIconData warning = SvgIconData(
    path: 'assets/svg/warning.svg',
  );
}

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.icon, {
    Key? key,
    this.size,
    this.color,
    this.semanticLabel,
  }) : super(key: key);

  final SvgIconData? icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon!.path,
      width: size,
      height: size,
      color: color,
      semanticsLabel: semanticLabel,
    );
  }
}
