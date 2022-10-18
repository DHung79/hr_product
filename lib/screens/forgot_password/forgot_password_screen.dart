import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';
import '../../core/authentication/auth.dart';
import '../../main.dart';
import '../../themes/jt_theme.dart';
import '../../widgets/jt_text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: AuthenticationBlocController().authenticationBloc,
        listener: (context, state) async {
          if (state is AuthenticationFailure) {
            // _showError(state.errorCode);
          }
          if (state is ForgotPasswordDoneState) {
            navigateTo(otpRoute);
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, size) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: size.maxWidth < 500
                    ? EdgeInsets.zero
                    : const EdgeInsets.all(30),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: size.maxWidth - 32),
                      child: Form(
                        autovalidateMode: _autovalidate,
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            backButton(),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                inputFields(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 0, 8),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: navigatoDot(),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget backButton() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            navigateTo(authenticationRoute);
          },
          child: ClipOval(
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                border: Border.all(color: JTColors.n200),
                color: JTColors.nWhite,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgIcon(
                  SvgIcons.arrowBackward,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Quên mật khẩu',
            style: JTTextStyle.h4Bold(color: JTColors.n800),
          ),
        ),
      ],
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
              child: _errorMessage.isNotEmpty
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
                if (_errorMessage.isNotEmpty) {
                  _errorMessage = '';
                }
              });
            },
            validator: (value) {
              if (value!.isEmpty || value.trim().isEmpty) {
                _errorMessage = 'Tài khoản hoặc mật khẩu không được để trống';
                return '';
              }
              if (!isEmail(value.trim())) {
                _errorMessage = 'Email không hợp lệ';
                return '';
              } else {
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
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Widget navigatoDot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 10,
          decoration: BoxDecoration(
            color: JTColors.pPurple,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: JTColors.n300,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: JTColors.n300,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  // _showError(String errorCode) async {
  //   setState(() {
  //     _errorMessage = showError(errorCode, context);
  //   });
  // }
}
