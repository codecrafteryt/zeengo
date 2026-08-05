/*
  ---------------------------------------
  Project: khelo yar Mobile Application
  Date: March 30, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: custom text field
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final double? fontSize;
  final FontWeight hintFontWeight;
  final TextEditingController controller;
  final bool isObscureText;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color hintColor;
  final Color textColor;
  final Color cursorColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Color fillColor;
  final Color focusedBorderColor;
  final Color focusedFillColor;
  final Color focusedTextColor;
  final double? width;
  final double? height;
  final Widget? suffixIcon;
  final bool showCustomSendIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onPrefixIconPressed;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Color? labelColor;
  final TextStyle? floatingLabelStyle;
  final double enabledBorderWidth;
  final double focusedBorderWidth;
  final Color? errorBorderColor;
  final double errorBorderWidth;
  final double focusedErrorBorderWidth;
  final int? maxLength;
  final String? allowedPattern;
  final bool preventSpaces;
  final ValueChanged<String>? onChanged;
  final bool filled;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.hintText,
    required this.controller,
    this.hintFontWeight = FontWeight.w400,
    this.isObscureText = false,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(5),
    this.borderColor = Colors.grey,
    this.hintColor = Colors.grey,
    this.textColor = Colors.black,
    this.cursorColor = Colors.black,
    this.prefixIcon,
    this.prefixIconColor,
    this.fillColor = Colors.white,
    this.focusedBorderColor = Colors.transparent,
    this.focusedFillColor = Colors.white,
    this.focusedTextColor = Colors.black,
    this.fontSize,
    this.width,
    this.height,
    this.suffixIcon,
    this.showCustomSendIcon = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onPrefixIconPressed,
    this.contentPadding,
    this.focusNode,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.allowedPattern,
    this.preventSpaces = false,
    this.onChanged,
    this.floatingLabelBehavior,
    this.labelColor,
    this.floatingLabelStyle,
    this.enabledBorderWidth = 1,
    this.focusedBorderWidth = 1.5,
    this.errorBorderColor,
    this.errorBorderWidth = 1.2,
    this.focusedErrorBorderWidth = 1.5,
    this.filled = true,
  });

  static const _errorColor = Color.fromRGBO(240, 66, 72, 1);

  @override
  Widget build(BuildContext context) {
    final resolvedFontSize = fontSize ?? 15.sp;
    final errorColor = errorBorderColor ?? _errorColor;
    final resolvedContentPadding = contentPadding ??
        EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: height != null ? 14.h : 13,
        );

    final radius = BorderRadius.circular(borderRadius);

    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        maxLength: maxLength,
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength!),
          if (allowedPattern != null)
            FilteringTextInputFormatter.allow(RegExp(allowedPattern!)),
          if (preventSpaces) FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          counterText: '',
          filled: filled,
          fillColor: fillColor,
          isDense: false,
          // Input box target height; avoid maxHeight so floating labels / errors
          // are not clipped (Material outlined style, 3rd SS).
          constraints: height != null
              ? BoxConstraints(minHeight: height!)
              : null,
          labelText: labelText,
          floatingLabelBehavior:
              floatingLabelBehavior ?? FloatingLabelBehavior.auto,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          alignLabelWithHint: true,
          hintText: hintText.isEmpty ? null : hintText,
          contentPadding: resolvedContentPadding,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: resolvedFontSize,
            fontWeight: hintFontWeight,
          ),
          labelStyle: TextStyle(
            color: labelColor ?? hintColor,
            fontSize: resolvedFontSize,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: floatingLabelStyle ??
              TextStyle(
                color: focusedBorderColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
          // Error: red floating label + message (Material outlined style).
          errorStyle: TextStyle(
            color: errorColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
          errorMaxLines: 2,
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              color: borderColor,
              width: enabledBorderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: focusedBorderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              color: errorColor,
              width: errorBorderWidth,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              color: errorColor,
              width: focusedErrorBorderWidth,
            ),
          ),
          suffixIcon: showCustomSendIcon
              ? Container(margin: EdgeInsets.only(right: 8.0.w))
              : suffixIcon,
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: prefixIconColor ?? hintColor,
                  size: 22.sp,
                )
              : null,
          prefixIconConstraints: prefixIcon != null
              ? BoxConstraints(minWidth: 44.w, minHeight: height ?? 48)
              : null,
          suffixIconConstraints: suffixIcon != null
              ? BoxConstraints(minWidth: 44.w, minHeight: height ?? 48)
              : null,
        ),
        style: TextStyle(
          color: textColor,
          fontSize: resolvedFontSize,
          height: 1.2,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: cursorColor,
        validator: validator,
        obscureText: isObscureText,
      ),
    );
  }
}
