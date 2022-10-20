import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_product/screens/register/form/enter_info_form.dart';
import 'package:hr_product/screens/register/form/register_form.dart';
import 'package:hr_product/themes/jt_navigator_dot.dart';
import '../../core/authentication/auth.dart';
import '../../main.dart';
import '../../themes/jt_theme.dart';
import '../otp/otp_form.dart';

class RegisterScreen extends StatefulWidget {
  final int pageIndex;
  const RegisterScreen({
    Key? key,
    this.pageIndex = 1,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            navigateTo(otpRegisterRoute);
          } else if (state is CheckOTPDoneState) {
            navigateTo(enterUserInfoRoute);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.pageIndex == 2)
                Padding(
                  padding: const EdgeInsets.only(top: 49),
                  child: JTButtons.backButton(
                    onTap: () {
                      navigateTo(registerRoute);
                    },
                    child: Text(
                      'Xác minh email',
                      style: JTTextStyle.h4Bold(color: JTColors.n800),
                    ),
                  ),
                ),
              const Spacer(),
              _getForm(),
              if (widget.pageIndex != 1)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  child: JTNavigatorDot(
                    itemCount: 2,
                    currentIndex: widget.pageIndex - 1,
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getForm() {
    if (widget.pageIndex == 1) {
      final screenSize = MediaQuery.of(context).size;
      final bottomHeight = MediaQuery.of(context).viewInsets.bottom;
      return SizedBox(
        height: screenSize.height - bottomHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 123, 0, 32),
                child: Container(
                  width: 162,
                  height: 106,
                  color: Colors.amber,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Chào mừng đến với HR Product',
                  style: JTTextStyle.h3Bold(color: JTColors.n800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: JTButtons.googleButon(
                  title: 'Đăng ký với Google',
                  onPressed: () {
                    // _signUpGoogle();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 17, 0, 37),
                child: JTDivider.or(),
              ),
              const RegisterForm(),
            ],
          ),
        ),
      );
    } else if (widget.pageIndex == 2) {
      return const OtpForm(
        isRegister: true,
      );
    } else {
      return const EnterInfoForm();
    }
  }
}
