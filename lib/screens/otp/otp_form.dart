import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hr_product/main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../themes/jt_theme.dart';

class OtpForm extends StatefulWidget {
  final bool isRegister;
  const OtpForm({
    Key? key,
    this.isRegister = false,
  }) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';
  final TextEditingController _otpController = TextEditingController();
  Timer? _delayResend;
  Timer? _delayCheckOtp;
  bool _lockResend = false;
  int _resendOtpCountDown = 180;
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
    return Form(
      autovalidateMode: _autovalidate,
      key: _key,
      child: Column(
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
          _actions(),
        ],
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
            borderWidth: 1,
            activeFillColor: JTColors.nBackground,
            selectedFillColor: JTColors.nBackground,
            // disabledColor: ColorApp.purpleColor,
            activeColor: _errorMessage.isNotEmpty
                ? JTColors.sysLightAlert
                : JTColors.nBackground,
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
              _errorMessage = 'Mã OTP không được để trống';
              return '';
            }
            if (_otpController.text != '1234') {
              _errorMessage = 'Mã OTP không chính xác';
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

  Widget _actions() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
          ),
          child: JTButtons.rounded(
            color: JTColors.pPurple,
            prefixIcon: SvgIcon(
              SvgIcons.check,
              color: JTColors.nWhite,
            ),
            child: Text(
              'Xác nhận',
              style: JTTextStyle.normalText(color: JTColors.nWhite),
            ),
            onPressed: () {
              _checkOTP();
            },
          ),
        ),
        _resendBuild(),
      ],
    );
  }

  _resendBuild() {
    if (_lockResend) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(
              'Gửi lại mã trong:',
              style: JTTextStyle.bodyMedium(
                color: JTColors.n500,
              ),
            ),
          ),
          Text(
            '${_resendOtpCountDown}s',
            style: JTTextStyle.bodyMedium(
              color: JTColors.n800,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Center(
            child: Text(
              'Bạn không nhận được mã?',
              style: JTTextStyle.bodyMedium(
                color: JTColors.n500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: JTButtons.rounded(
              color: JTColors.nWhite,
              prefixIcon: SvgIcon(
                SvgIcons.reload,
                color: JTColors.sysLightAction,
              ),
              child: Text(
                'Gửi lại',
                style: JTTextStyle.normalText(
                  color: JTColors.sysLightAction,
                ),
              ),
              onPressed: () {
                _resendOTP();
              },
            ),
          ),
        ],
      );
    }
  }

  _resendOTP() {
    setState(() {
      _otpController.clear();
      _errorMessage = '';
      _lockResend = true;
      _delayResend = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_resendOtpCountDown == 0) {
          setState(() {
            timer.cancel();
            _lockResend = false;
          });
        } else {
          setState(() {
            _resendOtpCountDown--;
          });
        }
      });
    });
    // AuthenticationBlocController().authenticationBloc.add(
    //       SendOTP(
    //         email: forgotPasswordEmailController.text,
    //       ),
    //     );
  }

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
      if (widget.isRegister) {
        navigateTo(enterUserInfoRoute);
      } else {
        navigateTo(resetPasswordRoute);
      }

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
