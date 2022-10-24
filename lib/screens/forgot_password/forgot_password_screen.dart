import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_product/themes/jt_navigator_dot.dart';
import '../../core/authentication/auth.dart';
import '../../main.dart';
import '../../themes/jt_theme.dart';
import './form/forgot_password_form.dart';
import '../otp/otp_form.dart';
import './form/reset_password_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final int pageIndex;
  const ForgotPasswordScreen({
    Key? key,
    this.pageIndex = 1,
  }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
            navigateTo(otpForgotPasswordRoute);
          } else if (state is CheckOTPDoneState) {
            navigateTo(resetPasswordRoute);
          }
        },
        child: LayoutBuilder(builder: (context, size) {
          final screenSize = MediaQuery.of(context).size;
          final bottomHeight = MediaQuery.of(context).viewInsets.bottom;
          return SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height - bottomHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.pageIndex != 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 49),
                        child: JTButtons.backButton(
                          onTap: () {
                            if (widget.pageIndex == 1) {
                              navigateTo(authenticationRoute);
                            } else {
                              navigateTo(forgotPasswordRoute);
                            }
                          },
                          child: Text(
                            widget.pageIndex == 1
                                ? 'Quên mật khẩu'
                                : 'Xác minh email',
                            style: JTTextStyle.h4Bold(color: JTColors.n800),
                          ),
                        ),
                      ),
                    const Spacer(),
                    _getForm(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                      ),
                      child: JTNavigatorDot(
                        itemCount: 3,
                        currentIndex: widget.pageIndex,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _getForm() {
    if (widget.pageIndex == 1) {
      return const ForgotPasswordForm();
    } else if (widget.pageIndex == 2) {
      return const OtpForm();
    } else {
      return const ResetPasswordForm();
    }
  }
}
