import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:validators/validators.dart';
import '../../core/authentication/auth.dart';
import '../../main.dart';
import '../../themes/jt_theme.dart';
import '../../widgets/jt_text_form_field.dart';

class LoginForm extends StatefulWidget {
  final AuthenticationState? state;
  const LoginForm({Key? key, this.state}) : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // bool _passwordSecure = true;
  String? _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool? _isKeepSession = false;
  bool _passwordSecure = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isRememberPassword = false;
  bool _isUserValidate = false;
  bool _isPasswordValidate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(GetLastUser());
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: AuthenticationBlocController().authenticationBloc,
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          // _showError(state.errorCode);
        } else if (state is LoginLastUser) {
          emailController.text = state.username;
          setState(() {
            _isKeepSession = state.isKeepSession;
          });
        }
      },
      child: LayoutBuilder(
        builder: (context, size) {
          return Column(
            children: [
              _googleLoginButon(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 17, 0, 37),
                child: _orDivider(),
              ),
              Form(
                autovalidateMode: _autovalidate,
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _inputFields(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                      child: Text(
                        _errorMessage!,
                        style: JTTextStyle.subMedium(
                          color: JTColors.sysLightAlert,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _passwordActions(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 16,
                      ),
                      child: JTButtons.rounded(
                        color: JTColors.pPurple,
                        child: Text(
                          'Đăng nhập',
                          style: JTTextStyle.normalText(color: JTColors.nWhite),
                        ),
                        onPressed: () => _login(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản?',
                          style: JTTextStyle.normalText(color: JTColors.n500),
                        ),
                        InkWell(
                          splashColor: JTColors.transparent,
                          highlightColor: JTColors.transparent,
                          onTap: () {
                            navigateTo(registerRoute);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.5,
                              vertical: 11.5,
                            ),
                            child: Text(
                              'Đăng ký',
                              style: JTTextStyle.link(
                                  color: JTColors.sysLightAction),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _googleLoginButon() {
    return JTButtons.outline(
      width: 338,
      height: 44,
      color: JTColors.nWhite,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: JTColors.pPurple),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            SvgIcons.google,
            size: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Đăng nhập với Google',
              style: JTTextStyle.normalText(color: JTColors.pPurple),
            ),
          ),
        ],
      ),
      onPressed: () {
        // _loginGoogle();
      },
    );
  }

  Widget _orDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1,
          width: 61,
          color: JTColors.n500,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Text(
            'Hoặc',
            style: JTTextStyle.normalText(color: JTColors.n500),
          ),
        ),
        Container(
          height: 1,
          width: 61,
          color: JTColors.n500,
        ),
      ],
    );
  }

  Widget _inputFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
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
                if (_errorMessage!.isNotEmpty) {
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
                if (_errorMessage!.isNotEmpty) {
                  _errorMessage = '';
                }
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                _isPasswordValidate = true;
                _errorMessage = 'Tài khoản hoặc mật khẩu không được để trống';
                return '';
              }
              if (value.length < 6) {
                _errorMessage = 'Mật khẩu có ít nhất 6 kí tự';
                _isPasswordValidate = true;
                return '';
              }
              if (value.length > 50) {
                _errorMessage = 'Mật khẩu có nhiều nhất 50 kí tự';
                _isPasswordValidate = true;
                return '';
              } else {
                _isPasswordValidate = false;
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _passwordActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          splashColor: JTColors.transparent,
          highlightColor: JTColors.transparent,
          onTap: () {
            setState(() {
              _isRememberPassword = !_isRememberPassword;
            });
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: _isRememberPassword
                    ? SvgIcon(
                        SvgIcons.checkMark,
                        color: JTColors.n800,
                      )
                    : SvgIcon(
                        SvgIcons.checkBox,
                        color: JTColors.n500,
                      ),
              ),
              Text(
                'Nhớ mật khẩu',
                style: JTTextStyle.normalText(color: JTColors.n800),
              ),
            ],
          ),
        ),
        InkWell(
          splashColor: JTColors.transparent,
          highlightColor: JTColors.transparent,
          onTap: () => navigateTo(forgotPasswordRoute),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
            child: Text(
              'Quên mật khẩu',
              style: JTTextStyle.link(color: JTColors.sysLightAction),
            ),
          ),
        ),
      ],
    );
  }

  _loginGoogle() async {
    setState(() {
      _errorMessage = '';
    });
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    AuthenticationBlocController().authenticationBloc.add(
          UserLoginGoogle(
            keepSession: _isKeepSession!,
            accessToken: googleAuth.accessToken!,
            isMobile: true,
          ),
        );
  }

  _login() {
    setState(() {
      _errorMessage = '';
    });
    if (widget.state is AuthenticationLoading) return;

    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // AuthenticationBlocController().authenticationBloc.add(
      //       UserLogin(
      //         email: emailController.text,
      //         password: passwordController.text,
      //         keepSession: _isKeepSession!,
      //         isMobile: true,
      //       ),
      //     );
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
