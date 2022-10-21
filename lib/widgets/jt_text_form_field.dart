import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/jt_theme.dart';

class JTTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool obscureText;
  final Function()? passwordIconOnPressed;
  final String? hintText;
  final Widget? prefixIcon;
  final bool isUnderLineBorder;
  final bool disableError;
  const JTTextFormField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.isPassword = false,
    this.obscureText = false,
    this.passwordIconOnPressed,
    this.hintText,
    this.prefixIcon,
    this.isUnderLineBorder = false,
    this.disableError = true,
  }) : super(key: key);

  @override
  State<JTTextFormField> createState() => _JTTextFormFieldState();
}

class _JTTextFormFieldState extends State<JTTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        style: TextStyle(color: JTColors.nBlack),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: widget.prefixIcon,
          ),
          suffixIcon: widget.isPassword
              ? TextButton(
                  onPressed: widget.passwordIconOnPressed,
                  child: widget.obscureText
                      ? SvgIcon(
                          SvgIcons.eye,
                          color: JTColors.n500,
                        )
                      : SvgIcon(
                          SvgIcons.eyeOff,
                          color: JTColors.n500,
                        ),
                )
              : null,
          filled: true,
          fillColor: JTColors.nWhite,
          // focusedBorder: widget.isUnderLineBorder
          //     ? UnderlineInputBorder(
          //         borderSide: BorderSide(
          //           width: 3.0,
          //           color: JTColors.sysLightAction,
          //         ),
          //         borderRadius: BorderRadius.circular(4),
          //       )
          //     : OutlineInputBorder(
          //         borderSide: BorderSide(
          //           color: JTColors.sysLightAction,
          //         ),
          //         borderRadius: BorderRadius.circular(4),
          //       ),
          enabledBorder: widget.isUnderLineBorder
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: JTColors.n300,
                  ),
                  borderRadius: BorderRadius.circular(4),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: JTColors.n300,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
          border: widget.isUnderLineBorder
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: JTColors.n300,
                  ),
                  borderRadius: BorderRadius.circular(4),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: JTColors.n300,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
          errorBorder: widget.isUnderLineBorder
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 3.0,
                    color: JTColors.sysLightAlert,
                  ),
                  borderRadius: BorderRadius.circular(4),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: JTColors.sysLightAlert,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
          errorStyle: widget.disableError ? const TextStyle(fontSize: 0) : null,
          hintText: widget.hintText,
          hintStyle: JTTextStyle.mediumBodyText(color: JTColors.n500),
        ),
        controller: widget.controller,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        validator: widget.validator,
      ),
    );
  }
}
