import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import '../../../main.dart';
import '../../../themes/jt_theme.dart';
import '../../../widgets/jt_text_form_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';
  final emailController = TextEditingController();
  bool _isUserValidate = false;
  
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
            'Nhập email hoặc\ntài khoản của bạn',
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
            'Chúng tôi sẽ gửi về email đăng kí của bạn\nnếu bạn dùng tên tài khoản',
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
                _errorMessage = 'Tài khoản hoặc mật khẩu không được để trống';
                return '';
              }
              if (!isEmail(value.trim())) {
                _isUserValidate = true;
                _errorMessage = 'Email không hợp lệ';
                return '';
              } else {
                _isUserValidate = false;
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget forgotPasswordButton() {
    return JTButtons.rounded(
      color: emailController.text.isNotEmpty
          ? JTColors.pPurple
          : JTColors.nDisable,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            SvgIcons.check,
            color: emailController.text.isNotEmpty
                ? JTColors.nWhite
                : JTColors.n300,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'Tiếp tục',
              style: JTTextStyle.normalText(
                color: emailController.text.isNotEmpty
                    ? JTColors.nWhite
                    : JTColors.n300,
              ),
            ),
          ),
        ],
      ),
      onPressed: emailController.text.isNotEmpty ? _forgotPassword : null,
    );
  }

  _forgotPassword() {
    setState(() {
      _errorMessage = '';
    });
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // AuthenticationBlocController().authenticationBloc.add(
      //       ForgotPassword(email: forgotPasswordEmailController.text),
      //     );
      navigateTo(otpForgotPasswordRoute);
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
