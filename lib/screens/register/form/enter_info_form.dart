import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../themes/jt_theme.dart';
import '../../../widgets/jt_text_form_field.dart';

class EnterInfoForm extends StatefulWidget {
  const EnterInfoForm({Key? key}) : super(key: key);

  @override
  State<EnterInfoForm> createState() => _EnterInfoFormState();
}

class _EnterInfoFormState extends State<EnterInfoForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final checkPasswordController = TextEditingController();

  String _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool _passwordSecure = true;
  bool _checkPasswordSecure = true;
  bool _isPasswordValidate = false;
  bool _isCheckPasswordValidate = false;

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
            child: forgotPasswordButton(),
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
            bottom: 16,
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
              child: _isPasswordValidate
                  ? SvgIcon(
                      SvgIcons.warning,
                      color: JTColors.sysLightAlert,
                    )
                  : SvgIcon(
                      SvgIcons.lock,
                      color: JTColors.n300,
                    ),
            ),
            hintText: 'Mật khẩu',
            isPassword: true,
            obscureText: _passwordSecure,
            controller: passwordController,
            passwordIconOnPressed: () {
              setState(() {
                _passwordSecure = !_passwordSecure;
              });
            },
            onSaved: (value) {
              passwordController.text = value!.trim();
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
                _isPasswordValidate = true;
                _errorMessage = 'Mật khẩu không được để trống';
                return '';
              }
              if (value.length < 6) {
                _isPasswordValidate = true;
                _errorMessage = 'Mật khẩu có ít nhất 6 kí tự';
                return '';
              }
              if (value.length > 50) {
                _isPasswordValidate = true;
                _errorMessage = 'Mật khẩu có nhiều nhất 50 kí tự';
                return '';
              } else {
                _errorMessage = '';
                _isPasswordValidate = false;
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: JTTextFormField(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: _isCheckPasswordValidate
                  ? SvgIcon(
                      SvgIcons.warning,
                      color: JTColors.sysLightAlert,
                    )
                  : SvgIcon(
                      SvgIcons.lock,
                      color: JTColors.n300,
                    ),
            ),
            hintText: 'Nhập lại mật khẩu mới',
            isPassword: true,
            obscureText: _checkPasswordSecure,
            controller: checkPasswordController,
            passwordIconOnPressed: () {
              setState(() {
                _checkPasswordSecure = !_checkPasswordSecure;
              });
            },
            onSaved: (value) {
              checkPasswordController.text = value!.trim();
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
                _isCheckPasswordValidate = true;
                if (!_isPasswordValidate) {
                  _errorMessage = 'Vui lòng nhập lại mật khẩu mới';
                }
                return '';
              }
              if (value.trim() != passwordController.text &&
                  passwordController.text.length >= 6) {
                _isCheckPasswordValidate = true;
                if (!_isPasswordValidate) {
                  _errorMessage = 'Mật khẩu không khớp';
                }
                return '';
              } else {
                _isCheckPasswordValidate = false;
                if (!_isPasswordValidate) {
                  _errorMessage = '';
                }
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget forgotPasswordButton() {
    final isActive = passwordController.text.isNotEmpty &&
        checkPasswordController.text.isNotEmpty;
    return JTButtons.rounded(
      color: isActive ? JTColors.pPurple : JTColors.nDisable,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            SvgIcons.check,
            color: isActive ? JTColors.nWhite : JTColors.n300,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'Tiếp tục',
              style: JTTextStyle.normalText(
                color: isActive ? JTColors.nWhite : JTColors.n300,
              ),
            ),
          ),
        ],
      ),
      onPressed: isActive ? _resetPassword : null,
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
}
