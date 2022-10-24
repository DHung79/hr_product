import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import '../../../main.dart';
import '../../../themes/jt_theme.dart';
import '../../../widgets/jt_text_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';
  final emailController = TextEditingController();
  bool _isUserValidate = false;

  final passwordController = TextEditingController();
  bool _passwordSecure = true;
  bool _isPasswordValidate = false;

  final checkPasswordController = TextEditingController();
  bool _checkPasswordSecure = true;
  bool _isCheckPasswordValidate = false;

  bool _acceptPolicy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Form(
        autovalidateMode: _autovalidate,
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    splashColor: JTColors.transparent,
                    highlightColor: JTColors.transparent,
                    onTap: () {
                      setState(() {
                        _acceptPolicy = !_acceptPolicy;
                      });
                    },
                    child: _acceptPolicy
                        ? SvgIcon(
                            SvgIcons.checkCircle,
                            color: JTColors.n800,
                          )
                        : SvgIcon(
                            SvgIcons.circle,
                            color: JTColors.n800,
                          ),
                  ),
                ),
                JTButtons.questionLink(
                  question: Text(
                    'Đồng ý với',
                    style: JTTextStyle.normalText(color: JTColors.n800),
                  ),
                  link: 'Điều khoản và Chính sách sử dụng',
                  onTap: () {
                    _showPolity();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7.5,
                    vertical: 11.5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
              ),
              child: registerButton(),
            ),
            JTButtons.questionLink(
              question: Text(
                'Đã có tài khoản?',
                style: JTTextStyle.normalText(color: JTColors.n500),
              ),
              link: 'Đăng nhập',
              onTap: () {
                navigateTo(authenticationRoute);
              },
              padding: const EdgeInsets.symmetric(
                horizontal: 7.5,
                vertical: 11.5,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget inputFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: JTTextFormField(
            disableError: false,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: _isUserValidate
                  ? SvgIcon(
                      SvgIcons.warning,
                      color: JTColors.sysLightAlert,
                    )
                  : SvgIcon(
                      SvgIcons.user,
                      color: JTColors.n300,
                    ),
            ),
            hintText: 'Tài khoản/Email',
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            onSaved: (value) {
              emailController.text = value!.trim();
            },
            onChanged: (value) {
              setState(() {
                if (_autovalidate == AutovalidateMode.onUserInteraction) {
                  _key.currentState!.validate();
                }
                if (_errorMessage.isNotEmpty) {
                  _errorMessage = '';
                }
              });
            },
            validator: (value) {
              if (value!.isEmpty || value.trim().isEmpty) {
                _isUserValidate = true;
                // _errorMessage = 'Tài khoản không được để trống';
                // return '';
                return 'Tài khoản không được để trống';
              }
              if (!isEmail(value.trim())) {
                _isUserValidate = true;
                // _errorMessage = 'Email không hợp lệ';
                // return '';
                return 'Email không hợp lệ';
              } else {
                _isUserValidate = false;
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: JTTextFormField(
            disableError: false,
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
                if (_errorMessage.isNotEmpty) {
                  _errorMessage = '';
                }
                if (_autovalidate == AutovalidateMode.onUserInteraction) {
                  _key.currentState!.validate();
                }
              });
            },
            validator: (value) {
              JTValidator.passwordValidator(value, (isValidate) {
                _isPasswordValidate = isValidate;
              }, (error) {
                _errorMessage = error;
              });
              if (_errorMessage.isNotEmpty) {
                return _errorMessage;
              } else {
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: JTTextFormField(
            disableError: false,
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
                if (_errorMessage.isNotEmpty) {
                  _errorMessage = '';
                }
                if (_autovalidate == AutovalidateMode.onUserInteraction) {
                  _key.currentState!.validate();
                }
              });
            },
            validator: (value) {
              if (value!.trim().isEmpty) {
                _isCheckPasswordValidate = true;
                // if (!_isPasswordValidate && !_isUserValidate) {
                //   _errorMessage = 'Vui lòng nhập lại mật khẩu mới';
                // }
                // return '';
                return 'Vui lòng nhập lại mật khẩu mới';
              }
              if (value.trim() != passwordController.text
                  // && passwordController.text.length >= 6
                  ) {
                _isCheckPasswordValidate = true;
                // if (!_isPasswordValidate && !_isUserValidate) {
                //   _errorMessage = 'Mật khẩu không khớp';
                // }
                // return '';
                return 'Mật khẩu không khớp';
              } else {
                _isCheckPasswordValidate = false;
                // if (!_isPasswordValidate && !_isUserValidate) {
                //   _errorMessage = '';
                // }
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget registerButton() {
    var isActive = emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        checkPasswordController.text.isNotEmpty;
    return JTButtons.rounded(
      color: emailController.text.isNotEmpty
          ? JTColors.pPurple
          : JTColors.nDisable,
      child: Text(
        'Tiếp tục',
        style: JTTextStyle.normalText(
          color: isActive ? JTColors.nWhite : JTColors.n300,
        ),
      ),
      onPressed: isActive ? _register : null,
    );
  }

  _register() {
    setState(() {
      _errorMessage = '';
    });
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // AuthenticationBlocController().authenticationBloc.add(
      //       ForgotPassword(email: forgotPasswordEmailController.text),
      //     );
      navigateTo(otpRegisterRoute);
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _showPolity() {}

  // _showError(String errorCode) async {
  //   setState(() {
  //     _errorMessage = showError(errorCode, context);
  //   });
  // }
}
