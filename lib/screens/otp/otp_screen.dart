import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_product/widgets/jt_indicator.dart';
import '../../core/authentication/bloc/authentication/authentication_bloc.dart';
import '../../core/authentication/bloc/authentication/authentication_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../main.dart';
import '../../themes/jt_navigator_dot.dart';
import '../../themes/jt_theme.dart';

class OtpScreen extends StatefulWidget {
  final bool isRegister;
  const OtpScreen({
    Key? key,
    this.isRegister = false,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _errorMessage = '';
  final TextEditingController _otpController = TextEditingController();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  Timer? _delayResend;
  Timer? _delayCheckOtp;
  bool _lockResend = false;
  bool _processing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  void dispose() {
    _delayCheckOtp?.cancel();
    _delayResend?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: AuthenticationBlocController().authenticationBloc,
        listener: (context, state) {
          if (state is AuthenticationFailure) {
            // _showError(state.errorCode);
          } else if (state is CheckOTPDoneState) {
            if (widget.isRegister) {
              navigateTo(enterUserInfoRoute);
            } else {
              navigateTo(resetPasswordRoute);
            }
          }
        },
        child: LayoutBuilder(
          builder: (context, size) {
            final screenSize = MediaQuery.of(context).size;
            final bottomHeight = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: size.maxWidth,
                  maxHeight: screenSize.height - bottomHeight,
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  autovalidateMode: _autovalidate,
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 49),
                        child: JTButtons.backButton(
                          onTap: () {
                            if (widget.isRegister) {
                              navigateTo(registerRoute);
                            } else {
                              navigateTo(forgotPasswordRoute);
                            }
                          },
                          child: Text(
                            'Xác minh email',
                            style: JTTextStyle.h4Bold(color: JTColors.n800),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _otpInput(),
                          Center(
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
                            child: otpButton(),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 24,
                            ),
                            child: JTNavigatorDot(
                              itemCount: 3,
                              currentIndex: 2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _otpInput() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
          ),
          child: Text(
            'Nhập mã OTP',
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
            'Chúng tôi đã gửi mã xác thực đến email của bạn.\nVui lòng kiểm tra tin nhắn đến.',
            style: JTTextStyle.subMedium(
              color: JTColors.n600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        PinCodeTextField(
          // backgroundColor: JTColors.nWhite,
          appContext: context,
          pastedTextStyle: JTTextStyle.standardMedium(
            color: JTColors.nBlack,
          ),
          enablePinAutofill: false,
          enableActiveFill: true,
          autoFocus: true,
          showCursor: true,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          length: 4,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: 48,
            fieldWidth: 48,
            activeFillColor: JTColors.nBackground,
            selectedFillColor: JTColors.nBackground,
            // disabledColor: ColorApp.purpleColor,
            activeColor: JTColors.nBackground,
            selectedColor: JTColors.n500,
            inactiveColor: JTColors.nBackground,
            inactiveFillColor: JTColors.nBackground,
          ),
          cursorColor: JTColors.nBlack,
          animationDuration: const Duration(milliseconds: 300),
          textStyle: JTTextStyle.h2Medium(color: JTColors.nBlack),
          controller: _otpController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              if (_errorMessage.isNotEmpty) {
                _errorMessage = '';
              }
            });
          },
          validator: (value) {
            if (value!.isEmpty || value.trim().isEmpty) {
              _errorMessage = '';
              return '';
            } else {
              _errorMessage = '';
              return null;
            }
          },
          onSaved: (value) {
            _otpController.text = value!;
          },
          onCompleted: (value) => _checkOTP(),
        ),
      ],
    );
  }

  Widget otpButton() {
    return JTButtons.rounded(
      color: JTColors.pPurple,
      prefixIcon: SvgIcon(
        SvgIcons.check,
        color: JTColors.nWhite,
      ),
      child: Text(
        'Xác nhận',
        style: JTTextStyle.normalText(color: JTColors.nWhite),
      ),
      onPressed: _checkOTP,
    );
  }

  // _resendOTP() {
  //   setState(() {
  //     _otpController.clear();
  //     _errorMessage = '';
  //     _lockResend = true;
  //     _delayResend = Timer.periodic(const Duration(minutes: 5), (timer) {
  //       if (timer.tick == 1) {
  //         timer.cancel();
  //         setState(() {
  //           _lockResend = false;
  //         });
  //       }
  //     });
  //   });
  //   AuthenticationBlocController().authenticationBloc.add(
  //         SendOTP(
  //           email: forgotPasswordEmailController.text,
  //         ),
  //       );
  // }

  _checkOTP() {
    setState(() {
      _processing = true;
      _delayCheckOtp = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (timer.tick == 1) {
          timer.cancel();
          setState(() {
            _processing = false;
          });
        }
      });
      _errorMessage = '';
    });
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      // if (widget.isRegister) {
      //   AuthenticationBlocController().authenticationBloc.add(
      //         CheckOTPRegister(otp: _otpController.text),
      //       );
      // } else {
      //   AuthenticationBlocController().authenticationBloc.add(
      //         CheckOTPForgot(otp: _otpController.text),
      //       );
      // }
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.always;
      });
    }
  }

  // _showError(String errorCode) {
  //   setState(() {
  //     _errorMessage = showError(errorCode, context);
  //   });
  // }
}
