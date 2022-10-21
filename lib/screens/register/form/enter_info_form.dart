import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import '../../../themes/jt_theme.dart';
import '../../../widgets/jt_dropdown.dart';
import '../../../widgets/jt_text_form_field.dart';

class EnterInfoForm extends StatefulWidget {
  const EnterInfoForm({Key? key}) : super(key: key);

  @override
  State<EnterInfoForm> createState() => _EnterInfoFormState();
}

class _EnterInfoFormState extends State<EnterInfoForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';

  final _userNameController = TextEditingController();
  bool _isUserNameValidate = false;

  final _dateController = TextEditingController();
  bool _isDateValidate = false;

  final _phoneNumberController = TextEditingController();
  bool _isPhoneNumberValidate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: _autovalidate,
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          inputFields(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
            child: Text(
              _errorMessage,
              style: JTTextStyle.subMedium(
                color: JTColors.sysLightAlert,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
            ),
            child: buildButtons(),
          ),
        ],
      ),
    );
  }

  Widget inputFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 24,
          ),
          child: Text(
            'Điền thông tin cá nhân',
            style: JTTextStyle.h2Bold(
              color: JTColors.n800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 48,
          ),
          child: Text(
            'Bước cuối cùng trước khi bắt đầu.',
            style: JTTextStyle.subMedium(
              color: JTColors.n600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: JTTextFormField(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: _isUserNameValidate
                  ? SvgIcon(
                      SvgIcons.warning,
                      color: JTColors.sysLightAlert,
                    )
                  : SvgIcon(
                      SvgIcons.user,
                      color: JTColors.n300,
                    ),
            ),
            hintText: 'Họ và Tên',
            controller: _userNameController,
            onSaved: (value) {
              _userNameController.text = value!.trim();
            },
            onChanged: (value) {
              setState(() {
                if (_autovalidate == AutovalidateMode.onUserInteraction) {
                  _key.currentState!.validate();
                }
              });
            },
            validator: (value) {
              if (value!.trim().isEmpty) {
                _isUserNameValidate = true;
                _errorMessage = 'Họ và Tên không được để trống';
                return '';
              } else {
                _errorMessage = '';
                _isUserNameValidate = false;
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Stack(
            children: [
              JTTextFormField(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _isDateValidate
                      ? SvgIcon(
                          SvgIcons.warning,
                          color: JTColors.sysLightAlert,
                        )
                      : SvgIcon(
                          SvgIcons.date,
                          color: JTColors.n300,
                        ),
                ),
                hintText: 'Ngày sinh',
                controller: _dateController,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    _isDateValidate = true;
                    _errorMessage = 'Ngày sinh không được để trống';
                    return '';
                  } else {
                    _errorMessage = '';
                    _isDateValidate = false;
                    return null;
                  }
                },
              ),
              JTButtons.rounded(
                onPressed: () async {
                  _datePickerRoute().then((value) {
                    logDebug(value);
                    _dateController.text =
                        DateFormat('dd/MM/yyyy').format(value!);
                  });
                },
                child: Container(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 76, minHeight: 44),
                child: JTDropdownButtonFormField<String>(
                  title: 'Giới tính',
                  titleStyle: JTTextStyle.bodyMedium(color: JTColors.n800),
                  defaultValue: '+84',
                  dataSource: const [
                    {'name': '+84', 'value': '+84'},
                  ],
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Thiếu giới tính';
                    }
                    return null;
                  },
                  onChanged: (newValue) {},
                  onSaved: (newValue) {},
                  onTap: () {},
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: JTTextFormField(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _isPhoneNumberValidate
                          ? SvgIcon(
                              SvgIcons.warning,
                              color: JTColors.sysLightAlert,
                            )
                          : SvgIcon(
                              SvgIcons.mobilePhone,
                              color: JTColors.n300,
                            ),
                    ),
                    hintText: 'Số điện thoại',
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        _isPhoneNumberValidate = true;
                        _errorMessage = 'Số điện thoại không được để trống';
                        return '';
                      }
                      String pattern =
                          r'^(\+843|\+845|\+847|\+848|\+849|\+841|03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        _isPhoneNumberValidate = true;
                        _errorMessage = 'Số điện thoại không hợp lệ';
                        return '';
                      } else {
                        _errorMessage = '';
                        _isPhoneNumberValidate = false;
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButtons() {
    final isActive =
        _userNameController.text.isNotEmpty && _dateController.text.isNotEmpty;
    return Column(
      children: [
        JTButtons.rounded(
          color: isActive ? JTColors.pPurple : JTColors.nDisable,
          child: Text(
            'Hoàn thành',
            style: JTTextStyle.normalText(
              color: isActive ? JTColors.nWhite : JTColors.n300,
            ),
          ),
          onPressed: isActive ? _resetPassword : null,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28),
          child: JTButtons.rounded(
            color: JTColors.nWhite,
            width: 127,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    'Bỏ qua',
                    style: JTTextStyle.normalText(
                      color: JTColors.n500,
                    ),
                  ),
                ),
                SvgIcon(
                  SvgIcons.arrowForward,
                  color: JTColors.n500,
                ),
              ],
            ),
            onPressed: () {
              navigateTo(homeRoute);
            },
          ),
        ),
      ],
    );
  }

  _resetPassword() {
    setState(() {
      _errorMessage = '';
    });
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // AuthenticationBlocController().authenticationBloc.add(
      //       ForgotPassword(email: forgotPasswordEmailController.text),
      //     );
      navigateTo(homeRoute);
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  // _showError(String errorCode) async {
  //   setState(() {
  //     _errorMessage = showError(errorCode, context);
  //   });
  // }

  Future<DateTime?> _datePickerRoute() {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDate: now,
      firstDate: DateTime(now.year - 200),
      lastDate: DateTime(now.year + 200),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: JTColors.pPurple, // header background color
              onPrimary: JTColors.nWhite, // header text color
              onSecondary: JTColors.nBlack,
              onSurface: JTColors.nBlack, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: JTColors.pPurple, // button text color
              ),
            ),
            textTheme: TextTheme(
              labelSmall: JTTextStyle.overline(), // label of the top
              headlineMedium: JTTextStyle.headline4(), //header style
              titleSmall: JTTextStyle.subtitle2(), // dropdown button style
              bodySmall: JTTextStyle.body1(), //calendar body text
              labelLarge: JTTextStyle.subtitle2(), //button text style
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
