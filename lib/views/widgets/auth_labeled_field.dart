/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Description: Label + CustomTextField (+ optional password visibility).
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/extensions/extentions.dart';
import '../../utils/values/my_color.dart';
import '../../utils/values/my_fonts.dart';
import 'custom_textfield.dart';

class AuthLabeledField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final bool isPassword;
  final String? helperText;
  final String? Function(String?)? validator;

  const AuthLabeledField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.helperText,
    this.validator,
  });

  @override
  State<AuthLabeledField> createState() => _AuthLabeledFieldState();
}

class _AuthLabeledFieldState extends State<AuthLabeledField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: MyFonts.plusJakartaSans,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: MyColors.blackDark,
          ),
        ),
        8.sbh,
        SizedBox(
          width: double.infinity,
          child: CustomTextField(
          hintText: widget.hint,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          isObscureText: widget.isPassword && _obscure,
          borderRadius: 12.r,
          padding: EdgeInsets.zero,
          borderColor: MyColors.borderSubtle,
          focusedBorderColor: MyColors.brandPrimary,
          hintColor: MyColors.grayscale30,
          textColor: MyColors.blackDark,
          cursorColor: MyColors.brandPrimary,
          prefixIcon: widget.prefixIcon,
          prefixIconColor: MyColors.grayscale40,
          fillColor: MyColors.white,
          focusedFillColor: MyColors.white,
          fontSize: 15.sp,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
          validator: widget.validator,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: MyColors.grayscale40,
                    size: 22.sp,
                  ),
                )
              : null,
        ),
        ),
        if (widget.helperText != null) ...[
          6.sbh,
          Text(
            widget.helperText!,
            style: TextStyle(
              fontFamily: MyFonts.plusJakartaSans,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: MyColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
